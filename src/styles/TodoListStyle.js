import {StyleSheet} from 'react-native';

export const style = StyleSheet.create({
    item: {
        flexDirection: `column`,
        padding: 8,
        marginBottom: 4,
    },
    itemHeader: {
        flexDirection: `row`,
        justifyContent: 'space-between',
    },
    itemFooter: {
        flexDirection: `row`,
        justifyContent: 'space-between',
    }
});
