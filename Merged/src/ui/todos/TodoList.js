import {ActivityIndicator, FlatList, Image, Platform, RefreshControl, View} from 'react-native';
import React from 'react';
import {splashStyle, todoListStyle, toolbarStyle} from '../../styles/Styles';
import {connect} from "react-redux";
import Action from '../../action/todos';
import Icon from 'react-native-vector-icons/Ionicons';
import {Text, TouchableRipple} from 'react-native-paper';
import TodoItem from "./TodoItem";
import {calculateTargetDate, getProgress, pickColorBetween, prettyPeriod, showErrorAlert} from "../../utils";
import moment from "moment";
import {STATE} from "../../reducer/todos";
import {NativeAppModule} from '../../native/Native';

export const ITEM_TYPE_TODO = `ITEM_TYPE_TODO`;
export const ITEM_TYPE_SEPARATOR = `ITEM_TYPE_SEPARATOR`;
const SEPARATOR_ID = -1;

class TodoList extends React.PureComponent {

    static navigationOptions = ({navigation}) => {
        return {
            title: 'Routine',
            headerTitleStyle: toolbarStyle.title,
            headerLeft: () => (
                <TouchableRipple style={toolbarStyle.menuItem}
                                 borderless={true}
                                 onPress={navigation.getParam('menuClicks')}>
                    <Icon name="md-menu" size={24} color="#000000"/>
                </TouchableRipple>
            ),
            headerRight: () => (
                <TouchableRipple style={toolbarStyle.menuItem}
                                 borderless={true}
                                 onPress={navigation.getParam('navigateToDetails')}>
                    <Icon name="md-add" size={24} color="#000000"/>
                </TouchableRipple>
            )
        }
    };

    componentDidMount() {
        this.props.requestTodos();

        this.props.navigation.setParams({
            navigateToDetails: () => {
                this.props.selectTodo(this.props.item);
                this.props.navigation.navigate(`Details`)
            },
            menuClicks: () => {
                NativeAppModule.onMenuClicked()
            }
        });
    }

    render() {
        const {items, isScrollEnabled, todoFetchState, actionState} = this.props;
        const uiItems = items ? toUiModels(items) : [];
        if (todoFetchState.isProgress && uiItems.length === 0) {
            return getProgress()
        } else if (todoFetchState.isError && uiItems.length === 0){
            return emptyErrorView()
        } else if (uiItems.length === 0){
            return emptyListView()
        }

        if (actionState.isError && !this.isActionErrorShown) {
            this.isActionErrorShown = true
            showErrorAlert(() => {
                this.isActionErrorShown = false
                this.props.todoActionState(STATE.empty)
            })
        }

        return <View style={{
            flex: 1,
            justifyContent: 'center'
        }}>
            <FlatList style={{flex: 1}}
                      contentContainerStyle={todoListStyle.container}
                      scrollEnabled={isScrollEnabled}
                      data={uiItems}
                      keyExtractor={item => item.id}
                      renderItem={({item}) => <TodoItem item={item}/>}
                      refreshControl={
                          <RefreshControl refreshing={todoFetchState.isProgress} onRefresh={() => {
                              this.props.requestTodos();
                          }}/>
                      }
            />{actionState.isProgress ? getProgress() : null}
        </View>
    }
}

const emptyErrorView = () => {
    return <View style={{flex: 1, justifyContent: `center`}}>
        <Text style={todoListStyle.errorMessage}>An error occurred!</Text>
    </View>
}

const emptyListView = () => {
    return <View style={{flex: 1, justifyContent: `center`, alignItems: `center`}}>
        <Image
            style={todoListStyle.emptyListImage}
            source={require('./empty_list.png')}
        />
        <Text style={todoListStyle.emptyListTitle}>Oh! it's still empty</Text>
        <Text style={todoListStyle.emptyListDescription}>There are no routine tasks</Text>
    </View>
}

const mapStateToProps = (state) => ({
        items: state.todos.items,
        isScrollEnabled: state.todos.isScrollEnabled,
        todoFetchState: state.todos.todoFetchState,
        actionState: state.todos.todoActionState
    }
);

export default connect(mapStateToProps, Action)(TodoList)

const toUiModels = (todos) => {
    const currentTime = moment().startOf("day");
    const sortTodos = todos.slice().sort((value1, value2) => {
        return moment(value1.timestamp).diff(currentTime, `d`) - moment(value2.timestamp).diff(currentTime, `d`)
    });
    const uiTodos = [];
    let lastExpiredTodoFound = false;
    let lastExpiredTodoIndex = 0;
    for (let i = 0; i < sortTodos.length; i++) {
        const item = sortTodos[i];
        let todoTime = moment(item.timestamp);
        if (!lastExpiredTodoFound && !todoTime.isBefore(currentTime)) {
            if (uiTodos.length > 0) {
                uiTodos.push({
                    id: SEPARATOR_ID,
                    itemType: ITEM_TYPE_SEPARATOR
                });
                lastExpiredTodoIndex = i - 1;
            }
            lastExpiredTodoFound = true;
        }

        const todoColor = lastExpiredTodoFound ? pickColorBetween(i - lastExpiredTodoIndex + 1) : `#FF0000`;

        uiTodos.push({
            ...item,
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit),
            backgroundColor: todoColor,
            itemType: ITEM_TYPE_TODO
        })
    }
    return uiTodos;
};
