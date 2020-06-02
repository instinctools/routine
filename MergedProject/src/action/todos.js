import firestore from '@react-native-firebase/firestore';
import auth from '@react-native-firebase/auth';
import {calculateTimestamp} from "../utils";

const Action = {
    Type: {
        TODO_FETCH: `TODO_FETCH`,
        TODO_FETCH_RESULT: `TODO_FETCH_RESULT`,
        TODO_DELETE: 'todo-delete',
        TODO_ACTION: 'TODO_ACTION',
        TODO_RESET: 'todo-reset',

        TODO_ADD: 'todo-add',
        TODO_SELECT: 'todo-select',


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

Action.todoAction = () =>{
    return {
        type: Action.Type.TODO_ACTION
    }
};

Action.deleteTodoResult = id => {
    return {
        type: Action.Type.TODO_DELETE,
        id
    };
};

Action.deleteTodo = id => {
    return (dispatch) => {
        dispatch(Action.todoAction());
        return firestore()
            .collection("users")
            .doc(auth().currentUser.uid)
            .collection("todos")
            .doc(id)
            .delete()
            .then(dispatch(Action.deleteTodoResult(id)))
    }
};

Action.resetTodoResult = item => {
    return {
        type: Action.Type.TODO_RESET,
        item: item
    };
};

Action.resetTodo = item => {
    return (dispatch) => {
        dispatch(Action.todoAction());

        let newItem = Object.assign({}, item, {
            timestamp: calculateTimestamp(item.period, item.periodUnit)
        });

        return firestore()
            .collection("users")
            .doc(auth().currentUser.uid)
            .collection("todos")
            .doc(item.id)
            .set({
                id: newItem.id,
                period: newItem.period,
                periodUnit: newItem.periodUnit,
                timestamp: newItem.timestamp,
                title: newItem.title
            })
            .then(Action.resetTodoResult(newItem))
    }
};

export default Action;
