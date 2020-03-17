import {Alert, Button, FlatList, Text, TouchableOpacity, View, TouchableHighlight} from 'react-native';
import React from 'react';
import Swipeable from 'react-native-swipeable-row';
import {todoListStyle, toolbarStyle} from '../styles/Styles';
import moment from "moment";
import {connect} from "react-redux";
import Action from '../action/todos';
import {calculateTargetDate, pickColorBetween, prettyPeriod} from "../utils";
import Icon from 'react-native-vector-icons/Ionicons';

const ITEM_TYPE_TODO = `ITEM_TYPE_TODO`;
const ITEM_TYPE_SEPARATOR = `ITEM_TYPE_SEPARATOR`;

export class TodoList extends React.Component {

    static navigationOptions = ({navigation}) => {
        return {
            title: 'Routine',
            headerTitleStyle: toolbarStyle.title,
            headerRight: () => (
                <TouchableOpacity style={toolbarStyle.menuIcon}
                    onPress={navigation.getParam('navigateToDetails')}>
                    <Icon name="md-add" size={24}/>
                </TouchableOpacity>
            )
        }
    };

    constructor(props, context) {
        super(props, context);
        this.state = {items: []}
    }

    componentDidMount() {
        this.props.navigation.setParams({
            navigateToDetails: () => (this.props.navigation.navigate(`Details`))
        });
    }

    render() {
        console.log(`TodoList render state: ${JSON.stringify(this.state)}`);
        console.log(`TodoList render props: ${JSON.stringify(this.props)}`);
        const items = this.state ? toUiModels(this.state.items) : [];
        return (
            <View style={{position: "relative"}}>
                <FlatList style={todoListStyle.container}
                          data={items}
                          keyExtractor={item => item.id}
                          renderItem={({item}) => createItemView(item, this.props)}
                />
            </View>

        );
    }

    static getDerivedStateFromProps(props, state) {
        return {...state, items: props.items};
    }
}

const createItemView = (item, props) => {
    if (item.itemType === ITEM_TYPE_SEPARATOR) {
        return <View style={todoListStyle.itemExpiredSeparator}/>
    } else {
        return <Swipeable
            leftContent={createSwipeableContent(`Reset`, `flex-end`)}
            rightContent={createSwipeableContent(`Delete`, `flex-start`)}
            onLeftActionRelease={() => props.resetTodo(item.id)}
            onRightActionRelease={() =>
                Alert.alert(
                    '',
                    "Are you sure want to delete this task?",
                    [
                        {
                            text: 'Cancel',
                            style: 'cancel',
                        },
                        {
                            text: 'Delete',
                            onPress: () => props.deleteTodo(item.id)
                        },
                    ]
                )}
        >
            <TouchableOpacity
                onPress={() => {
                    props.navigation.navigate("Details", {id: item.id})
                }}>
                <View style={{...todoListStyle.item, backgroundColor: item.backgroundColor}}>
                    <View style={todoListStyle.itemHeader}>
                        <Text style={todoListStyle.itemHeaderText}>{item.title}</Text>
                    </View>
                    <View style={todoListStyle.itemFooter}>
                        <Text style={todoListStyle.itemFooterText}>{item.periodStr}</Text>
                        <Text style={todoListStyle.itemFooterText}>{item.targetDate}</Text>
                    </View>
                </View>
            </TouchableOpacity>
        </Swipeable>
    }
};

const createSwipeableContent = (text, alignItems) => (
    <View style={{ flex: 1, alignItems: alignItems}}>
        <Text style={todoListStyle.itemSwipeContent}>
            {text}
        </Text>
    </View>
);

export default connect(
    previousState => {
        const {todos} = previousState;
        return {...todos};
    },
    Action
)(TodoList);

const toUiModels = (todos) => {
    const currentTime = moment().startOf("day");
    const sortTodos = todos.slice().sort((value1, value2) => {
        return moment(value1.timestamp).diff(currentTime, `d`) - moment(value2.timestamp).diff(currentTime, `d`)
    });
    const uiTodos = [];
    let lastExpiredTodoFound = false;
    for (let i = 0; i < sortTodos.length; i++) {
        const item = sortTodos[i];
        let todoTime = moment(item.timestamp);
        if (!lastExpiredTodoFound && !todoTime.isBefore(currentTime)) {
            if (uiTodos.length > 0) {
                uiTodos.push({itemType: ITEM_TYPE_SEPARATOR});
            }
            lastExpiredTodoFound = true
        }
        uiTodos.push({
            ...item,
            targetDate: calculateTargetDate(todoTime),
            periodStr: prettyPeriod(item.period, item.periodUnit),
            backgroundColor: pickColorBetween(i),
            itemType: ITEM_TYPE_TODO
        })
    }
    return uiTodos;
};
