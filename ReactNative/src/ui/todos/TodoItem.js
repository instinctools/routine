import React from 'react';
import {Alert, Text, View} from 'react-native';
import Swipeable from 'react-native-swipeable-row';
import {todoListStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import Action from "../../action/todos";
import {connect} from "react-redux";
import {ITEM_TYPE_SEPARATOR} from "./TodoList";
import {withNavigation} from 'react-navigation';

class TodoItem extends React.Component {

    shouldComponentUpdate(nextProps, nextState) {
        return JSON.stringify(nextProps.item) !== JSON.stringify(this.props.item) ||
            JSON.stringify(nextProps.isMenuActivated) !== JSON.stringify(this.props.isMenuActivated) ||
            JSON.stringify(nextState) !== JSON.stringify(this.state);
    }

    render() {
        const {item} = this.props;
        console.log(`TodoItem render: item: ${JSON.stringify(item)}`);
        if (item.itemType === ITEM_TYPE_SEPARATOR) {
            return <View style={todoListStyle.itemExpiredSeparator}/>
        } else {
            return <Swipeable
                onLeftActionActivate={() => this.props.changeMenuActivationState(item.id, true)}
                onLeftActionDeactivate={() => this.props.changeMenuActivationState(item.id, false)}
                onRightActionActivate={() => this.props.changeMenuActivationState(item.id, true)}
                onRightActionDeactivate={() => this.props.changeMenuActivationState(item.id, false)}
                onSwipeStart={() => (this.props.changeScrollState(false))}
                onSwipeComplete={() => (this.props.changeScrollState(true))}
                leftContent={createSwipeableContent(`Reset`, `flex-end`, this.props.isMenuActivated)}
                rightContent={createSwipeableContent(`Delete`, `flex-start`, this.props.isMenuActivated)}
                onLeftActionRelease={() => this.props.resetTodo(item.id)}
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
                                onPress: () => this.props.deleteTodo(item.id)
                            },
                        ]
                    )}
            >
                <TouchableRipple
                    style={{...todoListStyle.item, backgroundColor: item.backgroundColor}}
                    borderless={true}
                    onPress={() => {
                        this.props.selectTodo(item.id, item.title, item.period, item.periodUnit);
                        this.props.navigation.navigate("Details")
                    }}>
                    <View>
                        <View style={todoListStyle.itemHeader}>
                            <Text style={todoListStyle.itemHeaderText}>{item.title}</Text>
                        </View>
                        <View style={todoListStyle.itemFooter}>
                            <Text style={todoListStyle.itemFooterText}>{item.periodStr}</Text>
                            <Text style={todoListStyle.itemFooterText}>{item.targetDate}</Text>
                        </View>
                    </View>
                </TouchableRipple>
            </Swipeable>
        }
    }
}

const createSwipeableContent = (text, alignItems, isMenuActivated) => {
    let color;
    if (isMenuActivated) {
        color = `#b2b2b2`;
    } else {
        color = '#E3E3E3';
    }

    return <View style={{flex: 1, alignItems: alignItems}}>
        <View style={{
            ...todoListStyle.itemSwipeContent,
            backgroundColor: color,
        }}>
            <Text style={todoListStyle.itemSwipeText}>
                {text}
            </Text>
        </View>
    </View>;
};

const mapStateToProps = (state, ownProps) => {
    return {
        isMenuActivated: state.todos.menuActivation.id === ownProps.item.id && state.todos.menuActivation.isMenuActivated
    };
};


export default withNavigation(connect(mapStateToProps, Action)(TodoItem))
