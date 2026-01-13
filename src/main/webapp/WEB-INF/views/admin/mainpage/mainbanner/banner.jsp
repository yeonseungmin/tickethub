<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html>

	<head>
		<meta charset="UTF-8">
		<title>메인 배너 관리</title>
		<style>
			.banner-img-preview {
				max-width: 200px;
				max-height: 100px;
				object-fit: cover;
				border-radius: 4px;
				border: 1px solid #ddd;
			}

			.drag-handle {
				cursor: move;
			}

			.drag-handle:hover {
				color: #007bff;
			}

			#banner-list-body tr.ui-sortable-helper {
				background: #f8f9fa;
				box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
			}
		</style>
	</head>

	<body>

		<div class="content-header">
			<div class="container-fluid">
				<h4 class="m-0">메인 배너 관리</h4>
			</div>
		</div>

		<section class="content">
			<div class="container-fluid">

				<!-- 배너 목록 -->
				<div class="card card-info">
					<div class="card-header d-flex justify-content-between align-items-center">
						<h3 class="card-title">현재 등록된 배너 목록</h3>
						<button type="button" class="btn btn-sm btn-warning ml-auto" id="btn-save-order">
							<i class="fas fa-save"></i> 순서 저장
						</button>
					</div>
					<div class="card-body table-responsive p-0">
						<table class="table table-hover text-nowrap">
							<thead>
								<tr>
									<th style="width: 40px;"></th>
									<th style="width: 60px;">순서</th>
									<th>이미지</th>
									<th>연결된 공연</th>
									<th>관리</th>
								</tr>
							</thead>
							<tbody id="banner-list-body">
								<!-- 데이터가 들어올 body -->
							</tbody>
						</table>
					</div>
				</div>

				<!-- 2. 배너 등록 폼 -->
				<div class="card card-primary mt-4">
					<div class="card-header">
						<h3 class="card-title">새 배너 등록</h3>
					</div>
					<form id="regis-form" enctype="multipart/form-data">
						<div class="card-body">
							<div class="form-group">
								<label>메인 배너에 등록할 공연을 선택하세요</label>
								<select class="form-control select2" name="work_id" id="work_list">
									<option value="">선택된 공연 없음</option>
								</select>
							</div>
							<div class="form-group">
								<label>배너 이미지 선택 (1920x600 권장)</label>
								<input type="file" class="form-control" name="file" id="file">
							</div>
						</div>
						<div class="card-footer text-center">
							<button type="button" class="btn btn-success" id="btn-save">등록하기</button>
						</div>
					</form>
				</div>

			</div>
		</section>
		<script>
			(function () {
				// 공연 List 가져와서 select에 채우기
				const loadWorkList = () => {
					$.ajax({
						url: "/admin/performance/work/list",
						method: "GET",
						success: (workList) => {
							let optionTags = "";
							workList.forEach((work) => {
								optionTags += `<option value="\${work.work_id}">\${work.work_title}</option>`;
							});
							$("#work_list").html(optionTags);
						}
					});
				};

				const loadBannerList = () => {
					$.ajax({
						url: "/admin/mainpage/mainbanner/list",
						method: "GET",
						success: (bannerList) => {
							let tableRowsHtml = "";
							if (bannerList.length === 0) {
								tableRowsHtml = "<tr><td colspan='5' class='text-center'>등록된 배너가 없습니다.</td></tr>";
							} else {
								bannerList.forEach((banner, index) => {
									tableRowsHtml += `
									<tr data-id="\${banner.mainbanner_id}">
										<td class="drag-handle"><i class="fas fa-grip-vertical"></i></td>
										<td class="display-order">\${index + 1}</td>
										<td><img src="/banner/\${banner.main_image_url}" class="banner-img-preview"></td>
										<td>\${banner.work.work_title}</td>
										<td>
											<button class="btn btn-sm btn-danger" onclick="deleteBanner(\${banner.mainbanner_id})">삭제</button>
										</td>
									</tr>`;
								});
							}
							$("#banner-list-body").html(tableRowsHtml);

							// sortable 초기화
							$("#banner-list-body").sortable({
								handle: ".drag-handle",
								axis: "y",
								update: function (event, ui) {
									updateDisplayOrder();
								}
							});
						}
					});
				};

				// 순서 번호 업데이트 (화면 표시)
				const updateDisplayOrder = () => {
					$("#banner-list-body tr").each((index, tr) => {
						$(tr).find(".display-order").text(index + 1);
					});
				};

				// 순서 저장 함수
				const saveOrder = () => {
					const orderList = [];
					$("#banner-list-body tr").each((index, tr) => {
						const id = $(tr).data("id");
						if (id) {
							orderList.push({
								mainbanner_id: id,
								display_order: index + 1
							});
						}
					});

					if (orderList.length === 0) {
						alert("저장할 항목이 없습니다.");
						return;
					}

					$.ajax({
						url: "/admin/mainpage/mainbanner/updateOrder",
						type: "POST",
						contentType: "application/json",
						data: JSON.stringify(orderList),
						success: (response) => {
							alert(response.message);
						},
						error: () => {
							alert("순서 저장 중 오류가 발생했습니다.");
						}
					});
				};

				const saveBanner = () => {
					const fileSelection = $("#file").val();
					if (!fileSelection) {
						alert("이미지 파일을 선택해주세요.");
						return;
					}
					const formElement = $("#regis-form")[0];
					const multipartData = new FormData(formElement);
					$.ajax({
						url: "/admin/mainpage/mainbanner/regist",
						type: "POST",
						data: multipartData,
						processData: false,
						contentType: false,
						success: (response) => {
							alert(response.message);
							formElement.reset();
							loadBannerList();
						},
						error: (errorResponse) => {
							let errorMessage = "배너 등록 중 오류가 발생했습니다.";
							if (errorResponse.responseJSON && errorResponse.responseJSON.message) {
								errorMessage = errorResponse.responseJSON.message;
							}
							alert(errorMessage);
						}
					});
				};

				window.deleteBanner = (bannerId) => {
					if (!confirm("정말 삭제하시겠습니까?")) return;
					$.ajax({
						url: "/admin/mainpage/mainbanner/delete",
						type: "POST",
						data: { mainbanner_id: bannerId },
						success: (response) => {
							loadBannerList();
						},
						error: (errorResponse) => {
							let errorMessage = "삭제 처리 중 오류가 발생했습니다.";
							if (errorResponse.responseJSON && errorResponse.responseJSON.message) {
								errorMessage = errorResponse.responseJSON.message;
							}
							alert(errorMessage);
						}
					});
				};

				$(() => {
					loadWorkList();
					loadBannerList();
					$("#btn-save").click(() => {
						saveBanner();
					});
					$("#btn-save-order").click(() => {
						saveOrder();
					});
				});
			})();
		</script>
	</body>

	</html>