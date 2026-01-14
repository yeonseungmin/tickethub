<%@ page contentType="text/html; charset=UTF-8" %>
  <aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="/" class="brand-link" target="_blank">
      <img src="/static/adminlte/dist/img/sitelogo.jpg" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
      <span class="brand-text font-weight-light">Ticket Hub</span>
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
          <img src="/static/adminlte/dist/img/adminlogo.jpg" class="img-circle elevation-2" alt="User Image">
        </div>
        <div class="info">
          <a href="#" class="d-block">관리자</a>
        </div>
      </div>

      <!-- SidebarSearch Form -->
      <div class="form-inline">
        <div class="input-group" data-widget="sidebar-search">
          <input class="form-control form-control-sidebar" type="search" placeholder="Search" aria-label="Search">
          <div class="input-group-append">
            <button class="btn btn-sidebar">
              <i class="fas fa-search fa-fw"></i>
            </button>
          </div>
        </div>
      </div>

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          <!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->
              
		<li class="nav-item main-banner-item">
		  <a href="#" class="nav-link active">
		    <i class="nav-icon fas fa-tachometer-alt"></i>
		    <p>
		      메인페이지관리
		      <i class="right fas fa-angle-left"></i>
		    </p>
		  </a>
		  <ul class="nav nav-treeview">
		    <li class="nav-item" id="menu-main-banner">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>메인배너 관리</p>
		      </a>
		    </li>
		  </ul>
		  <ul class="nav nav-treeview">
		    <li class="nav-item" id="menu-hot-work">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>인기작 관리</p>
		      </a>
		    </li>
		  </ul>
		  <ul class="nav nav-treeview">
		    <li class="nav-item" id="menu-opening-work">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>오픈예정 관리</p>
		      </a>
		    </li>
		  </ul>
		  <ul class="nav nav-treeview">
		    <li class="nav-item" id="menu-genre-ranking">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>장르별 화제작 관리</p>
		      </a>
		    </li>
		  </ul>
		  <ul class="nav nav-treeview">
		    <li class="nav-item" id="menu-bestreview-work">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>베스트 관람후기 관리</p>
		      </a>
		    </li>
		  </ul>
		</li>      
               
          <li class="nav-item menu performance">
            <a href="#" class="nav-link active">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>
                공연상세
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>인물 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>장소 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>주최/기획 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>작품 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>회차 관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="#" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>신고 이력 조회</p>
                </a>
              </li>
            </ul>
          </li>
               
          <li class="nav-item menu">
            <a href="#" class="nav-link active">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>
                회원관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="#" class="nav-link" id="menu-members">
                  <i class="far fa-circle nav-icon"></i>
                  <p>회원 목록</p>
                </a>
              </li>
            </ul>
          </li>
          
		<li class="nav-item menu seat">
		  <a href="#" class="nav-link active">
		    <i class="nav-icon fas fa-tachometer-alt"></i>
		    <p>
		      좌석관리
		      <i class="right fas fa-angle-left"></i>
		    </p>
		  </a>
		  <ul class="nav nav-treeview">
		    <li class="nav-item">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>좌석상태관리</p>
		      </a>
		    </li>
		    <li class="nav-item">
		      <a href="#" class="nav-link">
		        <i class="far fa-circle nav-icon"></i>
		        <p>좌석등급관리</p>
		      </a>
		    </li>
		  </ul>
		</li>
                       
          <li class="nav-item menu">
            <a href="#" class="nav-link active">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>
                주문관리
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="./index.html" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>주문정보</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="./index2.html" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>결제관리</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="./index3.html" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>취소/반품내역</p>
                </a>
              </li>
            </ul>
          </li>
                       
          <li class="nav-item menu">
            <a href="#" class="nav-link active">
              <i class="nav-icon fas fa-tachometer-alt"></i>
              <p>
                고객센터
                <i class="right fas fa-angle-left"></i>
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="./index.html" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>문의 게시판</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="./index2.html" class="nav-link">
                  <i class="far fa-circle nav-icon"></i>
                  <p>FAQ</p>
                </a>
              </li>
              
            </ul>
          </li>
          
        </ul>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
  </aside>
  