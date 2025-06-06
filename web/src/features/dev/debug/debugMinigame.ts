import type { MinigameProps } from '../../../typings/minigame';
import { debugData } from '../../../utils/debugData';

export const debugMinigame = () => {
    debugData<MinigameProps | MinigameProps[]>([
        {
            action: 'fishingMinigame',
            data: [
                {
                    duration: 15000,
                    progress: { add: 0.1, remove: 0.05 },
                    speed: 0.02
                },
                {
                    duration: 25000,
                    progress: { add: 0.2, remove: 0.05 },
                    speed: 0.03
                }
            ]
        },
    ]);
};