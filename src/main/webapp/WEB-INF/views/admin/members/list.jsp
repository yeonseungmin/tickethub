<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
  /* ===== 팀원 스타일(topnav + content width) ===== */
  #content{
    width: 1200px;
    min-height: 700px;
    margin: 0 auto;
  }

  .topnav {
    overflow: hidden;
    background-color: #333;
    text-align: center;
    border-radius: 6px;
    margin: 12px 0 16px;
  }

  .topnav a {
    float: left;
    color: #f2f2f2;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
    font-size: 17px;
  }

  .topnav a:hover {
    background-color: #ddd;
    color: black;
  }

  .topnav a.active {
    background-color: #04AA6D;
    color: white;
  }

  /* 기존 뱃지 */
  .filter-row { gap: 10px; }
  .badge-pill { border-radius: 999px; padding: 6px 10px; font-weight: 700; display:inline-block; }
  .badge-normal { background:#e8f7ef; color:#0f5132; }
  .badge-blocked{ background:#fdecea; color:#842029; }
  .badge-admin  { background:#e7f1ff; color:#0b5ed7; }
  .badge-user   { background:#f1f3f5; color:#495057; }
</style>

<div id="content">

  <!-- topnav -->
  <div class="topnav">
    <a class="active" href="#" onclick="return false;">회원 목록</a>
  </div>

  <!-- Content Header -->
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4 class="m-0">회원 목록</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="#" onclick="return false;">Home</a></li>
            <li class="breadcrumb-item active">회원관리</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <!-- Main content -->
  <section class="content">
    <div class="container-fluid">

      <!-- 검색 카드 -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">검색 / 필터</h3>
          <div class="card-tools" style="color:#6b7280;">
            총 <b>${total}</b>명 · ${page} / ${totalPage} 페이지
          </div>
        </div>

        <div class="card-body">
          <!-- ✅ 중요: Ajax 환경이라 action으로 페이지 이동하면 안 됨 -> JS로 submit 처리 -->
          <form id="member-search-form">
            <div class="row filter-row">
              <div class="col-md-5">
                <label>키워드 (아이디/이름/이메일/전화)</label>
                <input class="form-control" type="text" name="keyword"
                       value="${keyword}" placeholder="예) hong / 홍길동 / 010 / email" />
              </div>

              <div class="col-md-3">
                <label>상태</label>
                <select class="form-control" name="status">
                  <option value="">전체</option>
                  <option value="NORMAL"  <c:if test="${status == 'NORMAL'}">selected</c:if>>NORMAL</option>
                  <option value="BLOCKED" <c:if test="${status == 'BLOCKED'}">selected</c:if>>BLOCKED</option>
                </select>
              </div>

              <div class="col-md-2">
                <label>등급ID</label>
                <input class="form-control" type="number" name="gradeId"
                       value="${gradeId}" placeholder="예) 1" />
              </div>

              <div class="col-md-2 d-flex align-items-end">
                <button class="btn btn-success w-100" type="submit">검색</button>
              </div>

              <div class="col-md-2 d-flex align-items-end">
                <button class="btn btn-secondary w-100" type="button" id="btn-reset">초기화</button>
              </div>
            </div>

            <input type="hidden" name="page" value="1"/>
          </form>
        </div>
      </div>

      <!-- 목록 카드 -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">회원 리스트</h3>
        </div>

        <div class="card-body table-responsive p-0">
          <table class="table table-hover text-nowrap">
            <thead>
              <tr>
                <th>ID</th>
                <th>아이디</th>
                <th>이름</th>
                <th>이메일</th>
                <th>전화</th>
                <th>상태</th>
                <th>권한</th>
                <th>등급</th>
                <th>가입일</th>
                <th>상세</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty members}">
                  <tr>
                    <td colspan="10" class="text-center text-muted" style="padding:24px;">
                      검색 결과가 없습니다.
                    </td>
                  </tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="m" items="${members}">
                    <tr>
                      <td>${m.memberId}</td>
                      <td>${m.loginId}</td>
                      <td>${m.name}</td>
                      <td>${m.email}</td>
                      <td>${m.phone}</td>

                      <td>
                        <c:choose>
                          <c:when test="${m.status == 'BLOCKED'}">
                            <span class="badge-pill badge-blocked">BLOCKED</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge-pill badge-normal">NORMAL</span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                      <td>
                        <c:choose>
                          <c:when test="${m.role == 'ADMIN'}">
                            <span class="badge-pill badge-admin">ADMIN</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge-pill badge-user">USER</span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                      <td>
                        <c:choose>
                          <c:when test="${not empty m.gradeName}">
                            ${m.gradeName} <span class="text-muted">(#${m.gradeId})</span>
                          </c:when>
                          <c:otherwise>
                            <span class="text-muted">등급 없음</span>
                          </c:otherwise>
                        </c:choose>
                      </td>

                      <td><fmt:formatDate value="${m.createdAt}" pattern="yyyy-MM-dd"/></td>

                      <td>
                        <a class="btn btn-sm btn-outline-primary btn-detail"
                           href="#"
                           data-memberid="${m.memberId}">
                          보기
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <!-- 페이징 -->
        <div class="card-footer clearfix">
          <ul class="pagination pagination-sm m-0 float-right">
            <c:if test="${page > 1}">
              <li class="page-item">
                <a class="page-link page-move" href="#" data-page="${page-1}">&laquo;</a>
              </li>
            </c:if>

            <c:forEach var="p" begin="1" end="${totalPage}">
              <c:choose>
                <c:when test="${p == page}">
                  <li class="page-item active"><span class="page-link">${p}</span></li>
                </c:when>
                <c:otherwise>
                  <li class="page-item">
                    <a class="page-link page-move" href="#" data-page="${p}">${p}</a>
                  </li>
                </c:otherwise>
              </c:choose>
            </c:forEach>

            <c:if test="${page < totalPage}">
              <li class="page-item">
                <a class="page-link page-move" href="#" data-page="${page+1}">&raquo;</a>
              </li>
            </c:if>
          </ul>
        </div>

      </div>

    </div>
  </section>
</div>

<script>
  (function(){
    // 현재 필터 값 유지하면서 다시 로드하는 함수
    function reloadMembers(extraParams){
      extraParams = extraParams || {};
      const baseParams = $("#member-search-form").serializeArray();
      const params = {};

      baseParams.forEach(p => params[p.name] = p.value);
      Object.keys(extraParams).forEach(k => params[k] = extraParams[k]);

      $.ajax({
        url: "/admin/members",
        method: "GET",
        data: params,
        success: function(result){
          $(".content-wrapper").html(result);
        }
      });
    }

    // 검색 submit -> Ajax로 다시 로드
    $("#member-search-form").on("submit", function(e){
      e.preventDefault();
      reloadMembers({ page: 1 });
    });

    // 초기화
    $("#btn-reset").on("click", function(){
      $.ajax({
        url: "/admin/members",
        method: "GET",
        success: function(result){
          $(".content-wrapper").html(result);
        }
      });
    });

    // 페이지 이동
    $(".page-move").on("click", function(e){
      e.preventDefault();
      const p = $(this).data("page");
      reloadMembers({ page: p });
    });

    // 상세 보기 (Ajax로 detail도 오른쪽에 띄우고 싶으면)
    $(".btn-detail").on("click", function(e){
      e.preventDefault();
      const memberId = $(this).data("memberid");

      $.ajax({
        url: "/admin/members/detail",
        method: "GET",
        data: { memberId: memberId },
        success: function(result){
          $(".content-wrapper").html(result);
        }
      });
    });
  })();
</script>