import {ScrollView, Text, TextInput, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import {todoDetailsStyle, toolbarStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import PeriodSelector from "./PeriodUnitSelector";
import ActionEditTodo from "../../action/EditTodoAction";
import Action from "../../action/todos";
import {getProgress, showErrorAlert} from "../../utils";
import {ResetType} from "../../constants";
import {STATE} from "../../reducer/todos";

const bgSelected = `#77767E`;
const bgUnSelected = `#EEEDF0`;

const textSelected = `#FFFFFF`;
const textUnselected = `#77767E`;

class DetailsScreen extends React.Component {

    static navigationOptions = ({navigation}) => {
        const {params} = navigation.state;
        console.log(`navigationOptions: params=${JSON.stringify(params)}`);
        const canBeSaved = params ? params.canBeSaved : undefined;
        return {
            title: '',
            headerRight: () => {
                if (canBeSaved) {
                    return (
                        <TouchableRipple style={toolbarStyle.menuItem}
                                         borderless={true}
                                         onPress={navigation.getParam('done')}>
                            <Text style={toolbarStyle.menuText}>Done</Text>
                        </TouchableRipple>
                    )
                } else {
                    return (
                        <View style={toolbarStyle.menuItem}>
                            <Text>Done</Text>
                        </View>
                    )

                }
            }
        }
    };

    componentDidMount() {
        this.props.navigation.setParams({
            done: () => {
                this.props.addTodo();
            }
        });
    }

    componentDidUpdate(prevProps, prevState) {
        const canBeSaved = this.props.navigation.getParam(`canBeSaved`);
        if (canBeSaved !== this.props.canBeSaved) {
            this.props.navigation.setParams({
                canBeSaved: this.props.canBeSaved
            });
        }
    }

    render() {
        console.log(`DetailsScreen render props: ${JSON.stringify(this.props)}`);
        const {editState, success, resetType} = this.props;
        if (success) {
            this.props.navigation.pop();
        }

        if (editState.isError && !this.isActionErrorShown) {
            this.isActionErrorShown = true
            showErrorAlert(() => {
                this.isActionErrorShown = false
                this.props.todoEditState(STATE.empty)
            })
        }

        return (
            <View style={{
                flex: 1
            }}>
                <ScrollView>
                    <View style={todoDetailsStyle.root}>
                        <TextInput
                            style={todoDetailsStyle.title}
                            selectionColor="#03dac6"
                            multiline={true}
                            placeholder="Type recurring task name..."
                            onChangeText={title => this.props.editTodoTitle(title)}
                            value={this.props.title}
                        />
                        <View style={{flexDirection: `row`, marginTop: 40}}>
                            {getResetBtn(this.props, resetType === ResetType.BY_PERIOD, "Reset to period", true, ResetType.BY_PERIOD)}
                            {getResetBtn(this.props, resetType === ResetType.BY_DATE, "Reset to date", false, ResetType.BY_DATE)}
                        </View>
                        <View style={todoDetailsStyle.separatorContainer}>
                            <View style={todoDetailsStyle.separatorLine}/>
                            <Text style={todoDetailsStyle.separatorText}>Repeat every</Text>
                        </View>
                        <PeriodSelector/>
                    </View>
                </ScrollView>
                {editState.isProgress ? getProgress() : null}
            </View>
        );
    }
}

const getResetBtn = (props, isSelected, text, isLeft, resetType) => {
    const bgColor = isSelected ? bgSelected : bgUnSelected;
    const textColor = isSelected ? textSelected : textUnselected;
    let defBtnStyle = {flex: 1, height: 36, backgroundColor: bgColor}
    let style
    if (isLeft) {
        style = {...defBtnStyle, borderTopLeftRadius: 6, borderBottomLeftRadius: 6}
    } else {
        style = {...defBtnStyle, borderBottomRightRadius: 6, borderTopRightRadius: 6}
    }

    return <TouchableRipple
        style={style}
        borderless={true}
        onPress={() => {
            props.changeResetType(resetType)
        }}>
        <Text style={{flex: 1, textAlign: `center`, textAlignVertical: `center`, color: textColor}}>{text}</Text>
    </TouchableRipple>
}

const mapStateToProps = (state) => {
    return {
        success: state.todos.editTodo.success,
        editState: state.todos.editTodo.todoEditState,
        canBeSaved: !(!state.todos.editTodo.title || state.todos.editTodo.todoEditState.isProgress),
        title: state.todos.editTodo.title,
        resetType: state.todos.editTodo.resetType
    }
};

export default connect(
    mapStateToProps, {
        ...ActionEditTodo,
        ...Action
    }
)(DetailsScreen);
