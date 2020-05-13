<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<h1>글작성</h1>
	<form action="insertform.do" method="post">
		<table border="1">
			<tr>
				<th>게시글 내용</th>
				<td><textarea rows="10" cols="60" name="board_content"></textarea></td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="작성"/>
					<input type="button" value="취소" onclick="#"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>