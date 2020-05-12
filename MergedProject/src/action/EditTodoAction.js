const ActionEditTodo = {
    Type: {
        TODO_EDIT_TITLE: `TODO_EDIT_TITLE`,
        TODO_EDIT_PERIOD: `TODO_EDIT_PERIOD`,
        TODO_EDIT_PERIOD_UNIT: `TODO_EDIT_PERIOD_UNIT`,
        TODO_EDIT_CHANGE_PERIOD_SELECTOR: `TODO_EDIT_CHANGE_PERIOD_SELECTOR`,
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

ActionEditTodo.changePeriodSelector = (isVisible) => {
    console.log(`edit todo change period selector state: ${isVisible}`);
    return {
        type: ActionEditTodo.Type.TODO_EDIT_CHANGE_PERIOD_SELECTOR,
        isVisible
    };
};

export default ActionEditTodo;
