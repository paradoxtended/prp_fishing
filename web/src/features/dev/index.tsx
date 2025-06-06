import { debugMinigame } from './debug/debugMinigame';

const Dev: React.FC = () => {
    return (
        <>
            <button onClick={() => debugMinigame()}>
                Open fishing minigame
            </button>
        </>
    )
};

export default Dev