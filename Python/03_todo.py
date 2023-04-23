# Created 19.02.2021
# ToDo Terminal Script using Markdown

import os
import sys

# creates the markdown file
TODO_FILE = 'todo.md'

# functions
def create_todo_file(file_path):
    # Create a new Markdown file if it doesn't exist yet
    if not os.path.exists(file_path):
        with open(file_path, 'w') as f:
            f.write('# To-Do List\n\n')

def add_task(file_path, task):
    # Add a new task to the to-do list
    create_todo_file(file_path)

    with open(file_path, 'a') as f:
        f.write('- [ ] {}\n'.format(task))

def remove_task(file_path, index):
    # Remove a task from the to-do list by its index.
    create_todo_file(file_path)

    tasks = get_tasks(file_path)

    try:
        del tasks[index]
    except IndexError:
        print('Task not found.')
        return

    with open(file_path, 'w') as f:
        for task in tasks:
            f.write('- [{}] {}\n'.format('x' if task.checked else ' ', task.text))

def get_tasks(file_path):
    # Get a list of tasks from the to-do list file
    create_todo_file(file_path)

    with open(file_path) as f:
        md = f.read()

    tasks = []

    for line in md.split('\n'):
        if line.strip().startswith('- ['):
            checked = True if line.strip()[3] == 'x' else False
            task_text = line.strip()[6:]
            tasks.append({'checked': checked, 'text': task_text})
    return tasks

def main():
    tasks = get_tasks(TODO_FILE)
    selected_task = 0
    while True:
        print('To-Do List:')
        for i, task in enumerate(tasks):
            print('{}. [{}] {}'.format(i, 'x' if task['checked'] else ' ', task['text']))
        
        print("\nWhat do you want to do?")
        print("1. Add a task")
        print("2. Mark a task as done")
        print("3. Quit")
        
        key = input('>> ')
        if key == '1':
            task = input('Enter a new task: ')
            add_task(TODO_FILE, task)
            tasks = get_tasks(TODO_FILE)
            selected_task = len(tasks) - 1
        elif key == '2':
            if not tasks:
                print('No tasks added yet.')
            else:
                index = input('Enter the index of the task to mark as done: ')
                try:
                    index = int(index)
                    if index < 0 or index >= len(tasks):
                        print('Invalid task index.')
                    else:
                        tasks[index]['checked'] = True
                        with open(TODO_FILE, 'w') as f:
                            for task in tasks:
                                f.write('- [{}] {}\n'.format('x' if task['checked'] else ' ', task['text']))
                except ValueError:
                    print('Invalid input. Please enter a number.')
        elif key == '3':
            sys.exit()
        else:
            continue
        
        # Clear the console and move the cursor to the top
        print("\033c", end="")
        print("\033[0;0H", end="")

# main
if __name__ == '__main__':
    main()
