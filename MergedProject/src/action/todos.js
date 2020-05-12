const Action = {
    Type: {
        TODO_ADD: 'todo-add',
        TODO_SELECT: 'todo-select',
        TODO_RESET: 'todo-reset',
        TODO_DELETE: 'todo-delete',
        TODO_CHANGE_MENU_ACTIVATION_STATE: 'todo-change-menu-activation-state',
        CHANGE_SCROLL_STATE: `change-scroll-state`,
        CHANGE_MENU_ACTIVATION_STATE: `change-menu-activation`
    }
};

Action.addTodo = () => {
    console.log(`action addTodo`);
    return {
        type: Action.Type.TODO_ADD
    };
};

Action.selectTodo = (id, title, period, periodUnit) => {
    console.log(`action select todo, id: ${id} title: ${title} period: ${period} periodUnit: ${periodUnit}`);
    return {
        type: Action.Type.TODO_SELECT,
        id,
        title,
        period,
        periodUnit
    }
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

Action.changeScrollState = (isScrollEnabled) => {
    console.log(`action change scroll state isScrollEnabled: ${isScrollEnabled}`);
    return {
        type: Action.Type.CHANGE_SCROLL_STATE,
        isScrollEnabled
    };
};

Action.changeMenuActivationState = (id, isMenuActivated) => {
    console.log(`action change menu activation state, id: ${id}, isMenuActivated: ${isMenuActivated}`);
    return {
        type: Action.Type.CHANGE_MENU_ACTIVATION_STATE,
        id,
        isMenuActivated
    };
};

export default Action;
