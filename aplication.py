from flask import Flask, jsonify, request, abort

app = Flask(__name__)

tasks = []
task_id_counter = 1

@app.route("/tasks", methods=["GET"])
def get_tasks():
    return jsonify(tasks)

@app.route("/tasks", methods=["POST"])
def add_task():
    global task_id_counter
    data = request.json
    if not data or 'title' not in data:
        abort(400, "Missing task title")
    task = {
        "id": task_id_counter,
        "title": data["title"],
        "done": False
    }
    tasks.append(task)
    task_id_counter += 1
    return jsonify(task), 201

@app.route("/tasks/<int:task_id>", methods=["PUT"])
def update_task(task_id):
    data = request.json
    for task in tasks:
        if task["id"] == task_id:
            task["title"] = data.get("title", task["title"])
            task["done"] = data.get("done", task["done"])
            return jsonify(task)
    abort(404)

@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    global tasks
    tasks = [task for task in tasks if task["id"] != task_id]
    return '', 204

if __name__ == "__main__":
    app.run(debug=True)
