import type { TabletProps } from '../../../typings/tablet';
import { debugData } from '../../../utils/debugData';

export const debugTablet = () => {
    debugData<TabletProps>([
        {
            action: 'openTablet',
            data: {
                myStats: {
                    fishesCaught: {
                        anchovy: { amount: 15, longest: 15.7 },
                        trout: { amount: 7, longest: 24.4 },
                    }
                }
            }
        },
    ]);
};