import {Modal, Text, View} from 'react-native';
import {TouchableRipple} from "react-native-paper";
import React from "react";
import {connect} from "react-redux";
import ActionEditTodo from "../../action/EditTodoAction";
import {todoDetailsStyle} from "../../styles/Styles";
import {WheelPicker} from "react-native-wheel-picker-android";

const pickerData = () => {
    const array = [];
    for (let i = 1; i <= 100; i++) {
        array.push(i.toString());
    }
    return array;
};


class PeriodSelector extends React.Component {
    render() {
        console.log(`PeriodSelector render props: ${JSON.stringify(this.props)}`);
        return <Modal animationType="slide"
                      visible={this.props.isVisible}
                      transparent={true}
                      onRequestClose = {() => this.props.changePeriodSelector(false)}>
            <View
                style={todoDetailsStyle.periodSelectorContainer}>
                <View style={todoDetailsStyle.periodSelectorCancelWrapper}>
                    <TouchableRipple
                        style={todoDetailsStyle.periodSelectorCancel}
                        borderless={true}
                        onPress={() => this.props.changePeriodSelector(false)}>
                        <Text>Close</Text>
                    </TouchableRipple>
                    <WheelPicker style={{width: `auto`, height: 196, marginTop: 24}}
                                 selectedItem={this.props.period - 1}
                                 indicatorColor={`#8B8B8B`}
                                 itemTextSize={24}
                                 selectedItemTextSize={24}
                                 selectedItemTextColor={`#8B8B8B`}
                                 data={pickerData()}
                                 onItemSelected={value => this.props.editTodoPeriod(value + 1)}
                    />
                </View>
            </View>
        </Modal>

    }
}

const mapStateToProps = (state) => {
    return {
        period: state.todos.editTodo.period,
        isVisible: state.todos.editTodo.isPeriodSelectorVisible
    };
};


export default connect(
    mapStateToProps,
    ActionEditTodo
)(PeriodSelector);
