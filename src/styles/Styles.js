import {StyleSheet} from 'react-native';

export const todoListStyle = StyleSheet.create({
    container: {
        marginVertical: 0,
    },
    item: {
        flexDirection: `column`,
        padding: 8,
        marginBottom: 4,
        borderRadius: 10,
        marginHorizontal: 16,
        marginVertical: 4
    },
    itemHeader: {
        flexDirection: `row`,
        justifyContent: 'space-between',
    },
    itemFooter: {
        flexDirection: `row`,
        justifyContent: 'space-between',
        fontSize: 14,
    },
    itemHeaderText:{
        fontSize: 18,
        color: `#ffffff`
    },
    itemFooterText:{
        fontSize: 14,
        color: `rgba(255, 255, 255, 0.7)`
    },
    itemSwipeContent:{
        flex: 1,
        width: 96,
        backgroundColor: '#E3E3E3',
        textAlignVertical: "center",
        textAlign: "center",
        borderRadius: 10,
        fontSize:20,
        color: `#FFFFFF`,
        marginVertical: 4
    }
});

export const toolbarStyle = StyleSheet.create({
    title: {
        fontSize: 32,
        fontWeight: 'bold'
    },
    menuIcon:{
        width: 48,
        height: 48,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
    }
});