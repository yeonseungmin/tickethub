# tickethub
중앙정보처리 1차 프로젝트 [ 연승민 강동훈 김태호 남여원 ]

이클립스 로드 후 추가 필수 세팅(직접 해야 함)

C:\Workspace\JavaFirstTeamWorkspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0
이 경로에 lib 라는 폴더 만들어서


C:\Users\shkdh\.m2\repository\com\mysql\mysql-connector-j\8.0.33
mysql jar 파일 직접 복사 해서 lib 폴더에 붙여넣기 해줘야 함

tickethub

mysql -h localhost -u root -p

create database tickethub;

create user 'tickethub'@'%' identified by '1234';

grant all privileges on tickethub.* to 'tickethub'@'%' with grant option;

flush privileges;
