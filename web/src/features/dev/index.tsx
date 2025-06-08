import { debugMinigame } from './debug/debugMinigame';
import { debugTablet } from './debug/debugTablet';

const Dev: React.FC = () => {
    return (
        <>
            <button onClick={() => debugMinigame()}>
                Open fishing minigame
            </button>
            <button onClick={() => debugTablet()}>
                Open fishing tablet
            </button>
        </>
    )
};

export default Dev