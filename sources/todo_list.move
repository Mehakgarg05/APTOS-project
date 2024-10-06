 module ToDoList::ToDoList {
    use std::signer;
    use aptos_framework::event::Event;

    struct Todo has key, store {
        id: u64,
        description: vector<u8>,
        priority: vector<u8>,
        category: vector<u8>,
        deadline: vector<u8>,
        completed: bool,
    }

    struct TodoList has key {
        owner: address,
        todos: vector<Todo>,
    }

    public fun initialize(account: &signer) {
        let owner_addr = signer::address_of(account);
        move_to(account, TodoList {
            owner: owner_addr,
            todos: vector::empty(),
        });
    }

    public fun add_todo(account: &signer, description: vector<u8>, priority: vector<u8>, category: vector<u8>, deadline: vector<u8>) {
        let list = borrow_global_mut<TodoList>(signer::address_of(account));
        let id = vector::length(&list.todos) as u64;
        let todo = Todo {
            id,
            description,
            priority,
            category,
            deadline,
            completed: false,
        };
        vector::push_back(&mut list.todos, todo);
    }

    public fun mark_complete(account: &signer, todo_id: u64) {
        let list = borrow_global_mut<TodoList>(signer::address_of(account));
        let todo = &mut list.todos[todo_id];
        todo.completed = true;
    }

    public fun get_todos(account: address): &vector<Todo> {
        let list = borrow_global<TodoList>(account);
        &list.todos
    }
}

