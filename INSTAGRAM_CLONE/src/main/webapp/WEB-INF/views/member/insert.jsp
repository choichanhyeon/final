<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<h1>���ۼ�</h1>
	<form action="insertform.do" method="post">
		<table border="1">
			<tr>
				<th>�Խñ� ����</th>
				<td><textarea rows="10" cols="60" name="board_content"></textarea></td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="�ۼ�"/>
					<input type="button" value="���" onclick="#"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>