<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
  #content{ width:1200px; min-height:700px; margin:0 auto; }
  .topnav{
    overflow:hidden; background:#333; text-align:center;
    border-radius:6px; margin:12px 0 16px;
  }
  .topnav a{
    float:left; color:#f2f2f2; padding:14px 16px;
    text-decoration:none; font-size:17px;
  }
  .topnav a:hover{ background:#ddd; color:#000; }
  .topnav a.active{ background:#04AA6D; color:#fff; }
</style>

<div id="content">

  <div class="topnav">
    <a href="#" class="active" onclick="return false;">회원 상세</a>
    <a href="#" id="btn-back-list">목록으로</a>
  </div>

  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4 class="m-0">회원 상세</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="#" id="crumb-home">Home</a></li>
            <li class="breadcrumb-item"><a href="#" id="crumb-members">회원관리</a></li>
            <li class="breadcrumb-item active">상세</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container-fluid">

      <div class="card">
        <div class="card-header">
          <h3 class="card-title">기본 정보</h3>
        </div>
        <div class="card-body">
          <table class="table table-bordered">
            <tr><th style="width:200px;">회원ID</th><td>${member.memberId}</td></tr>
            <tr><th>아이디</th><td>${member.loginId}</td></tr>
            <tr><th>이름</th><td>${member.name}</td></tr>
            <tr><th>이메일</th><td>${member.email}</td></tr>
            <tr><th>전화</th><td>${member.phone}</td></tr>
            <tr><th>상태</th><td>${member.status}</td></tr>
            <tr><th>권한</th><td>${member.role}</td></tr>
            <tr><th>등급</th><td>${member.gradeName} (#${member.gradeId})</td></tr>
            <tr><th>가입일</th><td><fmt:formatDate value="${member.createdAt}" pattern="yyyy-MM-dd"/></td></tr>
          </table>
        </div>
      </div>

      <!-- 상태 변경 -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">관리</h3>
        </div>
        <div class="card-body">

          <form id="form-status" class="form-inline" style="gap:10px;">
            <input type="hidden" name="memberId" value="${member.memberId}">
            <label>상태</label>
            <select class="form-control" name="status">
              <option value="NORMAL"  <c:if test="${member.status=='NORMAL'}">selected</c:if>>NORMAL</option>
              <option value="BLOCKED" <c:if test="${member.status=='BLOCKED'}">selected</c:if>>BLOCKED</option>
            </select>
            <button type="submit" class="btn btn-primary">상태 변경</button>
          </form>

          <hr>

          <form id="form-grade" class="form-inline" style="gap:10px;">
            <input type="hidden" name="memberId" value="${member.memberId}">
            <label>등급ID</label>
            <input type="number" class="form-control" name="gradeId" value="${member.gradeId}">
            <button type="submit" class="btn btn-success">등급 변경</button>
          </form>

        </div>
      </div>

    </div>
  </section>
</div>

<script>
(function(){

  // 목록으로 돌아갈 URL (list.jsp에서 pushState로 backUrl 넣어둔 걸 사용)
  function getBackUrl(){
    const st = history.state;
    if(st && st.backUrl) return st.backUrl;

    // 혹시 state 없으면 기본 목록
    return "/admin/members?page=1";
  }

  function loadListByUrl(url){
    // url: "/admin/members?keyword=..&page=.."
    $.ajax({
      url: url,
      method: "GET",
      success: function(result){
        // 목록으로 돌아갈 때 URL도 맞춰주기
        history.pushState({ view:"list", url:url }, "", url);
        $(".content-wrapper").html(result);
      }
    });
  }

  // detail에서 "목록으로" 버튼
  $("#btn-back-list").off("click").on("click", function(e){
    e.preventDefault();

    // 1순위: history가 정상이라면 back()
    // (list.jsp에서 listUrl → detailUrl 순으로 pushState 했기 때문)
    if(history.length > 1){
      history.back();
      return;
    }

    // 2순위: 안전망 - 직접 목록 Ajax 로드
    loadListByUrl(getBackUrl());
  });

  // breadcrumb 클릭도 목록으로
  $("#crumb-members").off("click").on("click", function(e){
    e.preventDefault();
    loadListByUrl(getBackUrl());
  });
  $("#crumb-home").off("click").on("click", function(e){
    e.preventDefault();
    // 홈은 너희 정책에 맞게 처리 (admin/main으로)
    $.ajax({
      url: "/admin/main",
      method: "GET",
      success: function(result){
        history.pushState({view:"main"}, "", "/admin/main");
        $(".content-wrapper").html(result);
      }
    });
  });

  // 상태 변경/등급 변경도 "전체 페이지 이동"이 아니라 Ajax로 처리 (fragment 유지)
  $("#form-status").off("submit").on("submit", function(e){
    e.preventDefault();
    $.ajax({
      url: "/admin/members/status",
      method: "POST",
      data: $(this).serialize(),
      success: function(){
        // 변경 후 detail 다시 로드
        const memberId = ${member.memberId};
        $.ajax({
          url: "/admin/members/detail",
          data: { memberId: memberId },
          success: function(result){
            $(".content-wrapper").html(result);
          }
        });
      }
    });
  });

  $("#form-grade").off("submit").on("submit", function(e){
    e.preventDefault();
    $.ajax({
      url: "/admin/members/grade",
      method: "POST",
      data: $(this).serialize(),
      success: function(){
        const memberId = ${member.memberId};
        $.ajax({
          url: "/admin/members/detail",
          data: { memberId: memberId },
          success: function(result){
            $(".content-wrapper").html(result);
          }
        });
      }
    });
  });

})();
</script>