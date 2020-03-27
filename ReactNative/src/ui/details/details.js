import {ScrollView, Text, TextInput, View} from 'react-native';
import React from 'react';
import {connect} from "react-redux";
import {todoDetailsStyle, toolbarStyle} from "../../styles/Styles";
import {TouchableRipple} from "react-native-paper";
import PeriodSelector from "./PeriodSelector";
import ActionEditTodo from "../../action/EditTodoAction";
import Action from "../../action/todos";

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
                this.props.navigation.pop();
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

    componentWillUnmount() {
        this.props.selectTodo()
    }

    render() {
        console.log(`DetailsScreen render props: ${JSON.stringify(this.props)}`);
        return (
            <ScrollView>
                <View style={todoDetailsStyle.root}>
                    <TextInput
                        style={todoDetailsStyle.title}
                        multiline={true}
                        placeholder="Type recurring task name..."
                        onChangeText={title => this.props.editTodoTitle(title)}
                    />
                    <View style={todoDetailsStyle.separatorContainer}>
                        <View style={todoDetailsStyle.separatorLine}/>
                        <Text style={todoDetailsStyle.separatorText}>Repeat</Text>
                    </View>
                    <PeriodSelector/>
                </View>
            </ScrollView>
        );
    }
}

const mapStateToProps = (state) => {
    return {
        canBeSaved: !(!state.todos.editTodo.title || !state.todos.editTodo.period || !state.todos.editTodo.periodUnit)
    }
};

export default connect(
    mapStateToProps, {
        ...ActionEditTodo,
        ...Action
    }
)(DetailsScreen);
