import firestore from '@react-native-firebase/firestore';
import auth from '@react-native-firebase/auth';
import {calculateTimestamp} from "../utils";
import uuid from "react-native-uuid";
import {Period, ResetType} from "../constants";
import moment from "moment";

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
                            timestamp: moment(documentSnapshot.data().timestamp.toDate()),
                            title: documentSnapshot.data().title,
                            resetType: documentSnapshot.data().resetType
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
    if (item.resetType === ResetType.BY_DATE) {
        let timeStamp = moment(item.timestamp)
        switch (item.periodUnit) {
            case Period.DAY:
                timeStamp.subtract(1, `days`)
                break
            case Period.WEEK:
                timeStamp.subtract(1, `weeks`)
                break
            case Period.MONTH:
                timeStamp.subtract(1, `months`)
                break
        }
        if (timeStamp.isAfter(moment())) {
            console.log("TEST123 AFTER")
            return {
                type: `any`
            }
        }
    }
    return (dispatch) => {
        dispatch(Action.todoAction());
        let todo = {
            id: item.id,
            period: item.period,
            periodUnit: item.periodUnit,
            resetType: item.resetType,
            timestamp: calculateTimestamp(item.period, item.periodUnit, item.resetType, item.timestamp),
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
        const period = editTodo.periods.find((currentPeriod) => {
            return currentPeriod.isSelected === true;
        })

        let todo = {
            id: editTodo.id,
            title: editTodo.title,
            resetType: editTodo.resetType,
            period: period.period,
            periodUnit: period.periodUnit,
            timestamp: calculateTimestamp(period.period, period.periodUnit, editTodo.resetType),
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
