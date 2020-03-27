const ActionEditTodo = {
    Type: {
        TODO_EDIT_TITLE: `todo-edit-title`,
        TODO_EDIT_PERIOD: `todo-edit-period`,
        TODO_EDIT_PERIOD_UNIT: `todo-edit-period-unit`,
    }
};

ActionEditTodo.editTodoTitle = (title) => {
    console.log(`edit todo title: ${title}`);
    return {
        type: ActionEditTodo.Type.TODO_EDIT_TITLE,
        title
    };
};

ActionEditTodo.editTodoPeriod = (period) => {
    console.log(`edit todo period: ${period}`);
    return {
        type: ActionEditTodo.Type.TODO_EDIT_PERIOD,
        period
    };
};

ActionEditTodo.editTodoPeriodUnit = (periodUnit) => {
    console.log(`edit todo period unit: ${periodUnit}`);
    return {
        type: ActionEditTodo.Type.TODO_EDIT_PERIOD_UNIT,
        periodUnit
    };
};

export default ActionEditTodo;
