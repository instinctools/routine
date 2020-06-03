import firestore from '@react-native-firebase/firestore';
import auth from '@react-native-firebase/auth';
import {calculateTimestamp} from "../utils";
import uuid from "react-native-uuid";

const Action = {
    Type: {
        TODO_FETCH: `TODO_FETCH`,
        TODO_FETCH_RESULT: `TODO_FETCH_RESULT`,
        TODO_DELETE: 'todo-delete',
        TODO_ACTION: 'TODO_ACTION',
        TODO_RESET: 'todo-reset',

        TODO_ADD: 'todo-add',
        TODO_SELECT: 'todo-select',
        TODO_PROGRESS: 'TODO_PROGRESS',

        TODO_CHANGE_MENU_ACTIVATION_STATE: 'todo-change-menu-activation-state',
        CHANGE_SCROLL_STATE: `change-scroll-state`,
        CHANGE_MENU_ACTIVATION_STATE: `change-menu-activation`
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

Action.todoAction = () => {
    return {
        type: Action.Type.TODO_ACTION
    }
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
            .then(dispatch({
                type: Action.Type.TODO_DELETE,
                id
            }))
    }
};

Action.resetTodo = item => {
    return (dispatch) => {
        dispatch(Action.todoAction());
        let todo = {
            id: item.id,
            period: item.period,
            periodUnit: item.periodUnit,
            timestamp: calculateTimestamp(item.period, item.periodUnit),
            title: item.title
        };
        return firestore()
            .collection("users")
            .doc(auth().currentUser.uid)
            .collection("todos")
            .doc(item.id)
            .set(todo)
            .then(dispatch({
                    type: Action.Type.TODO_RESET,
                    item: todo
                }
            ))
    }
};

Action.todoProgress = () => {
    return {
        type: Action.Type.TODO_PROGRESS
    }
};

Action.selectTodo = (todo) => {
    return {
        type: Action.Type.TODO_SELECT,
        todo: todo
    }
};

Action.addTodo = () => {
    return (dispatch, getState) => {
        let editTodo = getState().todos.editTodo;
        let todo = {
            id: editTodo.id,
            period: editTodo.period,
            periodUnit: editTodo.periodUnit,
            timestamp: calculateTimestamp(editTodo.period, editTodo.periodUnit),
            title: editTodo.title
        };

        if (todo.id === undefined) {
            todo.id = uuid.v1()
        }

        dispatch(Action.todoProgress());
        return firestore()
            .collection("users")
            .doc(auth().currentUser.uid)
            .collection("todos")
            .doc(todo.id)
            .set(todo)
            .then(() => {
                dispatch({
                    type: Action.Type.TODO_ADD,
                    todo: todo
                })
            })
    };
};

export default Action;
