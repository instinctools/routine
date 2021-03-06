import React from "react";
import {ActivityIndicator, Image, Text, View} from "react-native";
import {connect} from "react-redux";
import SplashAction from "../../action/SplashAction";
import {TouchableRipple} from "react-native-paper";
import {splashStyle} from "../../styles/Styles";
import auth from "@react-native-firebase/auth";

class DetailsScreen extends React.Component {
    static navigationOptions = {
        header: null
    };

    componentDidMount() {
        if (auth().currentUser === null) {
            this.props.startAuth()
        } else {
            this.props.navigation.replace("Items")
        }
    }

    render() {
        let {isProgress, isSuccess, isError} = this.props.splash
        if (isSuccess) {
            this.props.navigation.replace("Items")
        }
        let text = isError ? "An error occurred!" : "Setting up account"

        return <View style={{
            flex: 1,
        }}>
            <View style={{flex: 1, justifyContent: 'center'}}>
                <Image
                    style={splashStyle.image}
                    //TODO Check if it possible to replace by svg
                    source={require('./splash.png')}
                />

            </View>

            <View style={{flex: 1, alignItems: 'center'}}>
                <Text style={splashStyle.message}>{text}</Text>
                {
                    isError ?
                        <TouchableRipple
                            style={splashStyle.retryBtn}
                            onPress={() => {
                                let pro = this.props
                                this.props.startAuth()
                            }}
                            borderless={true}
                        >
                            <Text style={splashStyle.retryBtnText}>Retry</Text>
                        </TouchableRipple> :
                        getProgress()
                }
            </View>
        </View>
    }
}


const getProgress = () => {
    return (Platform.OS === 'ios') ?
        <ActivityIndicator style={{marginTop: 32}} size="large"/> :
        <ActivityIndicator style={{marginTop: 32}} color="#835D51" size={48}/>
}

const mapStateToProps = (state) => {
    return {
        splash: state.splash
    }
};

export default connect(
    mapStateToProps, {
        ...SplashAction
    }
)(DetailsScreen);
