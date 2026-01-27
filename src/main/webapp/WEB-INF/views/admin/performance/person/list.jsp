<%@page import="com.ch.tickethub.dto.Person"%>
<%@page import="java.util.List"%>
<%@page import="com.ch.tickethub.util.PagingUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 1. 데이터 가져오기
	List<Person> personList = (List)request.getAttribute("personList");

	// 2. 페이징 처리
	PagingUtil paging = new PagingUtil();
	paging.setPageSize(10); 
	paging.init(personList, request);
	
	int curPos = paging.getCurPos();
	int num = paging.getNum();
	System.out.println(personList);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<p>안녕하세요 person list.jsp예요!</p>
</body>
</html>