import { isEnvBrowser } from './utils/misc';
import Dev from './features/dev';
import FishingMinigame from './features/minigame/FishingMinigame';

const App: React.FC = () => {

  return (
    <>
      <FishingMinigame />
      {isEnvBrowser() && <Dev />}
    </>
  );
};

export default App;