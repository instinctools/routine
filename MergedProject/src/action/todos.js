import firestore from '@react-native-firebase/firestore';
import auth from '@react-native-firebase/auth';

const Action = {
    Type: {
        TODO_FETCH: `TODO_FETCH`,
        TODO_FETCH_RESULT: `TODO_FETCH_RESULT`,

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
    return {
        type: Action.Type.TODO_ADD
    };
};

Action.selectTodo = (id, title, period, periodUnit) => {
    return {
        type: Action.Type.TODO_SELECT,
        id,
        title,
        period,
        periodUnit
    }
};

Action.resetTodo = id => {
    return {
        type: Action.Type.TODO_RESET,
        id
    };
};
Action.deleteTodo = id => {
    return {
        type: Action.Type.TODO_DELETE,
        id
    };
};

Action.changeScrollState = (isScrollEnabled) => {
    return {
        type: Action.Type.CHANGE_SCROLL_STATE,
        isScrollEnabled
    };
};

Action.changeMenuActivationState = (id, isMenuActivated) => {
    return {
        type: Action.Type.CHANGE_MENU_ACTIVATION_STATE,
        id,
        isMenuActivated
    };
};

Action.fetchTodos = () => {
    return {
        type: Action.Type.TODO_FETCH
    };
};

Action.fetchResults = (todos) => {
    return {
        type: Action.Type.TODO_FETCH_RESULT,
        todos: todos
    };
};

Action.requestTodos = () => {
    return (dispatch) => {
        dispatch(Action.fetchTodos());
        return firestore()
            .collection("users")
            .doc(auth().currentUser.uid)
            .collection("todos")
            .get()
            .then(querySnapshot => {
                let todos = [];
                querySnapshot.forEach(documentSnapshot => {
                    todos.push({
                            id: documentSnapshot.data().id,
                            period: documentSnapshot.data().period,
                            periodUnit: documentSnapshot.data().periodUnit,
                            timestamp: documentSnapshot.data().timestamp,
                            title: documentSnapshot.data().title
                        }
                    )
                });
                dispatch(Action.fetchResults(todos))
            });
    }
};


export default Action;
