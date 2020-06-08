import {ScrollView, Text, TextInput, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import {todoDetailsStyle, toolbarStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import PeriodSelector from "./PeriodUnitSelector";
import ActionEditTodo from "../../action/EditTodoAction";
import Action from "../../action/todos";
import analytics from "@react-native-firebase/analytics";
import {getProgress} from "../../utils";

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
                analytics().logEvent('save_todo_react', {});
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
        const {isProgress, success} = this.props;
        if (success) {
            this.props.navigation.pop();
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
                        <View style={todoDetailsStyle.separatorContainer}>
                            <View style={todoDetailsStyle.separatorLine}/>
                            <Text style={todoDetailsStyle.separatorText}>Repeat</Text>
                        </View>
                        <PeriodSelector/>
                    </View>
                </ScrollView>
                {isProgress ? getProgress() : null}
            </View>
        );
    }
}

const mapStateToProps = (state) => {
    return {
        success: state.todos.editTodo.success,
        isProgress: state.todos.editTodo.isProgress,
        canBeSaved: !(!state.todos.editTodo.title || !state.todos.editTodo.period || !state.todos.editTodo.periodUnit || state.todos.editTodo.isProgress),
        title: state.todos.editTodo.title
    }
};

export default connect(
    mapStateToProps, {
        ...ActionEditTodo,
        ...Action
    }
)(DetailsScreen);
