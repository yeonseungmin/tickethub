<%@ page contentType="text/html; charset=UTF-8" %>
  <nav class="main-header navbar navbar-expand navbar-white navbar-light" style="justify-content: space-between;">

    <!-- 좌측 영역: 관리자 홈 링크 -->
    <ul class="navbar-nav">
      <li class="nav-item">
        <a href="/admin/main" class="nav-link" id="btn-admin-home" style="font-weight: 600; color: #333; font-size: 16px;">
          <i class="fas fa-home" style="margin-right: 6px;"></i>관리자 홈
        </a>
      </li>
    </ul>

    <!-- 우측 영역: 오늘 날짜 + 관리자 정보 -->
    <ul class="navbar-nav ml-auto" style="align-items: center;">

      <!-- 날짜 -->
      <li class="nav-item" style="margin-right: 20px;">
        <span id="today-date" style="font-size: 14px; color: #666;"></span>
      </li>

      <!-- 관리자 프로필 -->
      <li class="nav-item dropdown">
        <a class="nav-link" href="#" style="display: flex; align-items: center;">
          <img src="/static/assets/img/admin.png" alt="관리자"
            style="width: 32px; height: 32px; border-radius: 50%; margin-right: 8px; object-fit: cover;">
          <span style="font-weight: 500; color: #333;">관리자</span>
        </a>
      </li>

    </ul>
  </nav>

  <!-- 날짜 표시 스크립트 -->
  <script>
    document.addEventListener('DOMContentLoaded', function () {
      var today = new Date();
      var year = today.getFullYear();
      var month = String(today.getMonth() + 1).padStart(2, '0');
      var day = String(today.getDate()).padStart(2, '0');

      var dateStr = year + '년 ' + month + '월 ' + day + '일';
      document.getElementById('today-date').textContent = dateStr;
    });
  </script>