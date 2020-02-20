const Action = {
    Type: {
        TODO_ADD: 'todo-add',
        TODO_RESET: 'todo-reset'
    },
    Period: {
        DAY: 'DAY',
        WEEK: 'WEEK',
        MONTH: 'MONTH'
    }
};

let id = -1;

Action.addTodo = (title, periodUnit, period) => {
    console.log(`action addTodo, text: ${title}; periodUnit: ${periodUnit}; period: ${period}`);
    return {
        type: Action.Type.TODO_ADD,
        id: ++id,
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

export default Action;
