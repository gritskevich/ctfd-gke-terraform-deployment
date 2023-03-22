<!doctype html>
<html>
<head>
	<meta charset="UTF-8">
	<title>HR Database</title>
	<link rel="stylesheet" href="css/style.css" />
</head>

<body>
	<form action='' method="POST">
		<img src='./image/logo.png' id='logo'>
		<h2>HR Database</h2>
		<?php
			include('./config.php');
			if(isset($_POST['username']) && isset($_POST['password'])){
				if ($_POST['username'] == $username && hash('sha256', $_POST['password']) == $password){
					echo "<p id='left'>Welcome  ".htmlentities($_POST['username'])."</p>";
					echo '<input type="submit" value="LOG IN" href="./index.php" class="button" />';
				}
				else{
					echo "Unknown user or password";
					echo "<input type='submit' class='button' value='Back' />";
				}
			}
			else{
				?>
				<input type="text" name="username" class="text-field" placeholder="Username" />
	    		<input type="password" name="password" class="text-field" placeholder="Password" />
	   			<input type="submit" value="LOG IN" class="button" />
				<?php
			}
		?>

	</form>
</body>
</html>
