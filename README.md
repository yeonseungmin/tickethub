# tickethub
중앙정보처리 1차 프로젝트 [ 연승민 강동훈 김태호 남여원 ]

이클립스 로드 후 추가 필수 세팅(직접 해야 함)

=================================================
RootConfig.java
  registry.addResourceHandler("/photo/**").addResourceLocations("file:/home/tickethub/performance/");
  registry.addResourceHandler("/banner/**").addResourceLocations("file:/home/tickethub/banner/");
  //registry.addResourceHandler("/photo/**").addResourceLocations("file:/C:/tickethub/performance/");
  //registry.addResourceHandler("/banner/**").addResourceLocations("file:/C:/tickethub/banner/");

util/FileUtil.java
	public static String getRootDir() {
		return "/home/tickethub/performance";
		//return "C:/tickethub/performance";
	}
	
	public static String getRealRootDir() {
		return "/home/tickethub";
		//return "C:/tickethub";
	}

WEB-INF/web.xml
  <!-- 업로드 관련 설정 -->
  <multipart-config>
    <location>/home/tickethub/temp</location>	<!-- 이미지가 임시로 저장될 곳  -->
    <!-- <location>C:\tickethub\temp</location> -->
    <!-- <location>/Users/nam-yeowon/shopdata/temp</location> -->	<!-- 이미지가 임시로 저장될 곳  -->
    <max-file-size>5242880</max-file-size>		<!-- 파일 1개의 최대 용량 5M 제한 -->
    <max-request-size>10485760</max-request-size>		<!-- 요청 전체 크기 10M 제한-->
    <file-size-threshold>0</file-size-threshold>		<!-- 0일 경우 무조건 디스크 사용 -->
  </multipart-config>




redis 설치하는 법.

window 기준)

https://github.com/tporadowski/redis/releases 사이트 접속 후

Redis-x64-5.0.14.1.zip 파일 다운 > 아무경로에다가 압축해제

압축 해제한 파일들 중에서 "redis-server.exe" 찾아서 더블클릭.

cmd 창에 아스키 아트 그림뜨면서 포트번호 6379 뜨면 정상.

mysql 처럼 이클립스 가동 전 redis 서버 실행하고 톰캣 가동.

mac 기준)

Homebrew로 Redis 설치. 터미널 열어서,

brew install redis      엔터. > 다운로드 되면

redis-server      엔터. > 포트번호 6379 확인.

========================================================

C:\Workspace\JavaFirstTeamWorkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0
이 경로에 lib 라는 폴더 만들어서


C:\Users\shkdh\.m2\repository\com\mysql\mysql-connector-j\8.0.33
mysql jar 파일 직접 복사 해서 lib 폴더에 붙여넣기 해줘야 함

==========================================================

tickethub

mysql -h localhost -u root -p

create database tickethub;

create user 'tickethub'@'%' identified by '1234';

grant all privileges on tickethub.* to 'tickethub'@'%' with grant option;

flush privileges;
