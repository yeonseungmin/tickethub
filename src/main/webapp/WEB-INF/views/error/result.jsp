<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body style="background:yellow">
	<h3>에러 발생</h3>
	<p>이용에 불편을 드려 죄송합니다.</p>
	<%
		String msg = (String)request.getAttribute("msg");
		out.print(msg);
	%>
</body>
</html>