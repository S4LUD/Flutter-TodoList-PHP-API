<?php
// Set the content type to JSON
header('Content-Type: application/json');

// Database connection details
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'todo_app';

// Create a new PDO instance
try {
    $pdo = new PDO("mysql:host=$host;dbname=$database", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}

// Define the API response
$response = array();

// Check the request method
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Get todos for a specific user
        if (isset($_GET['userID'])) {
            $userID = $_GET['userID'];

            $stmt = $pdo->prepare("SELECT * FROM todos WHERE userID = :userID");
            $stmt->bindParam(':userID', $userID);
            $stmt->execute();
            $todos = $stmt->fetchAll(PDO::FETCH_ASSOC);

            $response['status'] = 'success';
            $response['todos'] = $todos;
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);

        // Check if it's a signup request
        if (isset($data['signup'])) {
            if (isset($data['username']) && isset($data['password'])) {
                $username = $data['username'];
                $password = password_hash($data['password'], PASSWORD_BCRYPT);

                try {
                    $stmt = $pdo->prepare("INSERT INTO users (username, password) VALUES (:username, :password)");
                    $stmt->bindParam(':username', $username);
                    $stmt->bindParam(':password', $password);
                    $stmt->execute();

                    $response['status'] = 'success';
                    $response['message'] = 'User registered successfully.';
                } catch (PDOException $e) {
                    if ($e->errorInfo[1] == 1062) { // 1062 is the MySQL error code for duplicate entry
                        $response['status'] = 'error';
                        $response['message'] = 'Username already exists. Please choose a different username.';
                    } else {
                        // Handle other database errors if needed
                        $response['status'] = 'error';
                        $response['message'] = 'Database error.';
                    }
                }
            } else {
                $response['status'] = 'error';
                $response['message'] = 'Invalid input. Username and password are required for signup.';
            }
        }


        // Check if it's a login request
        elseif (isset($data['login'])) {
            if (isset($data['username']) && isset($data['password'])) {
                $username = $data['username'];
                $rawPassword = $data['password'];

                // Retrieve the hashed password from the database
                $stmt = $pdo->prepare("SELECT userID, username, password FROM users WHERE username = :username");
                $stmt->bindParam(':username', $username);
                $stmt->execute();
                $user = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($user && password_verify($rawPassword, $user['password'])) {
                    // Passwords match, user is authenticated
                    $response['status'] = 'success';
                    $response['message'] = 'User authenticated successfully.';
                    $response['user_id'] = $user['userID'];
                    $response['username'] = $user['username'];
                } else {
                    // Passwords do not match, authentication failed
                    $response['status'] = 'error';
                    $response['message'] = 'Invalid username or password.';
                }
            } else {
                $response['status'] = 'error';
                $response['message'] = 'Invalid input. Username and password are required for user login.';
            }
        }

        // Check if it's a regular todo add request
        elseif (isset($data['title']) && isset($data['userID'])) {
            $title = $data['title'];
            $userID = $data['userID'];

            $stmt = $pdo->prepare("INSERT INTO todos (title, userID) VALUES (:title, :userID)");
            $stmt->bindParam(':title', $title);
            $stmt->bindParam(':userID', $userID);
            $stmt->execute();

            $response['status'] = 'success';
            $response['message'] = 'Todo added successfully.';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Invalid input. Title is required for a new todo.';
        }
        break;

    case 'PATCH':
        // Update a todo
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['todoID']) && isset($data['title'])) {
            $_todoID = $data['todoID'];
            $title = $data['title'];
            $stmt = $pdo->prepare("UPDATE todos SET title = :title WHERE todoID = :_todoID");
            $stmt->bindParam(':title', $title);
            $stmt->bindParam(':_todoID', $_todoID);
            $stmt->execute();

            $response['status'] = 'success';
            $response['message'] = 'Todo updated successfully.';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Invalid input. _ID and Title are required for updating a todo.';
        }
        break;

    case 'PUT':
        // Update todo status
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['todoID']) && isset($data['status'])) {
            $_todoID = $data['todoID'];
            $status = $data['status'];
            $stmt = $pdo->prepare("UPDATE todos SET status = :status WHERE todoID = :_todoID");
            $stmt->bindParam(':status', $status);
            $stmt->bindParam(':_todoID', $_todoID);
            $stmt->execute();

            $response['status'] = 'success';
            $response['message'] = 'Todo status updated successfully.';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Invalid input. _ID and Status are required for updating todo status.';
        }
        break;

    case 'DELETE':
        // Delete a todo
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['todoID'])) {
            $_todoID = $data['todoID'];
            $stmt = $pdo->prepare("DELETE FROM todos WHERE todoID = :_todoID");
            $stmt->bindParam(':_todoID', $_todoID);
            $stmt->execute();

            $response['status'] = 'success';
            $response['message'] = 'Todo deleted successfully.';
        } else {
            $response['status'] = 'error';
            $response['message'] = 'Invalid input. _ID is required for deleting a todo.';
        }
        break;

    default:
        $response['status'] = 'error';
        $response['message'] = 'Invalid request method.';
        break;
}

// Convert the response array to JSON and echo it
echo json_encode($response);
