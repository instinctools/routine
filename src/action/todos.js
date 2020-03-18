import uuid from "react-native-uuid";

const Action = {
    Type: {
        TODO_ADD: 'todo-add',
        TODO_EDIT: 'todo-edit',
        TODO_RESET: 'todo-reset',
        TODO_DELETE: 'todo-delete',
    }
};

Action.addTodo = (title, periodUnit, period) => {
    console.log(`action addTodo, text: ${title}; periodUnit: ${periodUnit}; period: ${period}`);
    return {
        type: Action.Type.TODO_ADD,
        id: uuid.v1(),
        title,
        periodUnit,
        period
    };
};
Action.editTodo = (id, title, periodUnit, period) => {
    console.log(`action editTodo, id: ${id}; text: ${title}; periodUnit: ${periodUnit}; period: ${period}`);
    return {
        type: Action.Type.TODO_EDIT,
        id,
        title,
        periodUnit,
        period
    };
};
Action.resetTodo = id => {
    console.log(`action resetTodo id: ${id}`);
    return {
        type: Action.Type.TODO_RESET,
        id
    };
};
Action.deleteTodo = id => {
    console.log(`action deleteTodo id: ${id}`);
    return {
        type: Action.Type.TODO_DELETE,
        id
    };
};

export default Action;
