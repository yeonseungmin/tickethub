<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
  /* list.jsp와 동일한 폭 규칙 */
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

  .badge-pill { border-radius: 999px; padding: 6px 10px; font-weight: 700; display:inline-block; }
  .badge-normal { background:#e8f7ef; color:#0f5132; }
  .badge-blocked{ background:#fdecea; color:#842029; }
  .badge-admin  { background:#e7f1ff; color:#0b5ed7; }
  .badge-user   { background:#f1f3f5; color:#495057; }
</style>

<div id="content">

  <!-- topnav -->
  <div class="topnav">
    <a href="#" id="nav-members">회원 목록</a>
    <a class="active" href="#" onclick="return false;">회원 상세</a>
  </div>

  <!-- Content Header -->
  <div class="content-header">
    <div class="container-fluid">
      <div class="row mb-2">
        <div class="col-sm-6">
          <h4 class="m-0">회원 상세</h4>
        </div>
        <div class="col-sm-6">
          <ol class="breadcrumb float-sm-right">
            <li class="breadcrumb-item"><a href="#" onclick="return false;">Home</a></li>
            <li class="breadcrumb-item"><a href="#" id="breadcrumb-members">회원관리</a></li>
            <li class="breadcrumb-item active">상세</li>
          </ol>
        </div>
      </div>
    </div>
  </div>

  <section class="content">
    <div class="container-fluid">

      <c:if test="${empty member}">
        <div class="card">
          <div class="card-body text-center text-muted" style="padding:24px;">
            회원 정보를 찾을 수 없습니다.
          </div>
        </div>
      </c:if>

      <c:if test="${not empty member}">
        <!-- 기본 정보 카드 -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">기본 정보</h3>
            <div class="card-tools">
              <button type="button" class="btn btn-sm btn-outline-secondary" id="btn-back">
                목록으로
              </button>
            </div>
          </div>

          <div class="card-body">
            <div class="row">

              <div class="col-md-6">
                <div class="form-group">
                  <label>ID</label>
                  <input type="text" class="form-control" value="${member.memberId}" readonly>
                </div>

                <div class="form-group">
                  <label>아이디</label>
                  <input type="text" class="form-control" value="${member.loginId}" readonly>
                </div>

                <div class="form-group">
                  <label>이름</label>
                  <input type="text" class="form-control" value="${member.name}" readonly>
                </div>

                <div class="form-group">
                  <label>이메일</label>
                  <input type="text" class="form-control" value="${member.email}" readonly>
                </div>

                <div class="form-group">
                  <label>전화</label>
                  <input type="text" class="form-control" value="${member.phone}" readonly>
                </div>
              </div>

              <div class="col-md-6">
                <div class="form-group">
                  <label>상태</label><br/>
                  <c:choose>
                    <c:when test="${member.status == 'BLOCKED'}">
                      <span class="badge-pill badge-blocked">BLOCKED</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge-pill badge-normal">NORMAL</span>
                    </c:otherwise>
                  </c:choose>
                </div>

                <div class="form-group">
                  <label>권한</label><br/>
                  <c:choose>
                    <c:when test="${member.role == 'ADMIN'}">
                      <span class="badge-pill badge-admin">ADMIN</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge-pill badge-user">USER</span>
                    </c:otherwise>
                  </c:choose>
                </div>

                <div class="form-group">
                  <label>등급</label>
                  <input type="text" class="form-control"
                         value="<c:out value='${member.gradeName}'/> ( #<c:out value='${member.gradeId}'/> )"
                         readonly>
                </div>

                <div class="form-group">
                  <label>가입일</label>
                  <input type="text" class="form-control"
                         value="<fmt:formatDate value='${member.createdAt}' pattern='yyyy-MM-dd'/>"
                         readonly>
                </div>

                <div class="form-group">
                  <label>마지막 로그인</label>
                  <input type="text" class="form-control"
                         value="<fmt:formatDate value='${member.lastLoginAt}' pattern='yyyy-MM-dd HH:mm'/>"
                         readonly>
                </div>
              </div>

            </div>
          </div>
        </div>

        <!-- 상태 변경 카드 -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">상태 변경</h3>
          </div>
          <div class="card-body">
            <form id="form-status">
              <input type="hidden" name="memberId" value="${member.memberId}"/>

              <div class="row">
                <div class="col-md-4">
                  <select class="form-control" name="status">
                    <option value="NORMAL"  <c:if test="${member.status == 'NORMAL'}">selected</c:if>>NORMAL</option>
                    <option value="BLOCKED" <c:if test="${member.status == 'BLOCKED'}">selected</c:if>>BLOCKED</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <button type="submit" class="btn btn-danger">상태 저장</button>
                </div>
              </div>
            </form>
            <small class="text-muted">※ 저장 시 현재 상세 화면이 자동 갱신됩니다.</small>
          </div>
        </div>

        <!-- 등급 변경 카드 -->
        <div class="card">
          <div class="card-header">
            <h3 class="card-title">등급 변경</h3>
          </div>
          <div class="card-body">
            <form id="form-grade">
              <input type="hidden" name="memberId" value="${member.memberId}"/>

              <div class="row">
                <div class="col-md-4">
                  <input type="number" class="form-control" name="gradeId" value="${member.gradeId}" min="1">
                </div>
                <div class="col-md-3">
                  <button type="submit" class="btn btn-primary">등급 저장</button>
                </div>
              </div>
            </form>
            <small class="text-muted">※ gradeId만 바꾸는 버전(등급 테이블 연동은 팀 규칙대로 확장).</small>
          </div>
        </div>

      </c:if>

    </div>
  </section>
</div>

<script>
  (function(){
    // ✅ list 화면 다시 로드
    function goMembersList(){
      $.ajax({
        url: "/admin/members",
        method: "GET",
        success: function(result){
          $(".content-wrapper").html(result);
        }
      });
    }

    // ✅ detail 화면 다시 로드(갱신용)
    function reloadDetail(memberId){
      $.ajax({
        url: "/admin/members/detail",
        method: "GET",
        data: { memberId: memberId },
        success: function(result){
          $(".content-wrapper").html(result);
        }
      });
    }

    // 목록으로 버튼
    $("#btn-back").on("click", function(){
      goMembersList();
    });

    // topnav/빵부스러기에서도 목록 이동
    $("#nav-members, #breadcrumb-members").on("click", function(e){
      e.preventDefault();
      goMembersList();
    });

    // ✅ 상태 변경: Ajax POST -> 성공하면 detail 갱신
    $("#form-status").on("submit", function(e){
      e.preventDefault();
      const memberId = $(this).find("input[name='memberId']").val();

      $.ajax({
        url: "/admin/members/status",
        method: "POST",
        data: $(this).serialize(),
        success: function(){
          reloadDetail(memberId);
        },
        error: function(){
          alert("상태 변경 중 오류가 발생했습니다.");
        }
      });
    });

    // ✅ 등급 변경: Ajax POST -> 성공하면 detail 갱신
    $("#form-grade").on("submit", function(e){
      e.preventDefault();
      const memberId = $(this).find("input[name='memberId']").val();

      $.ajax({
        url: "/admin/members/grade",
        method: "POST",
        data: $(this).serialize(),
        success: function(){
          reloadDetail(memberId);
        },
        error: function(){
          alert("등급 변경 중 오류가 발생했습니다.");
        }
      });
    });
  })();
</script>