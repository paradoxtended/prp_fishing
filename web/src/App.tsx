import { isEnvBrowser } from './utils/misc';
import Dev from './features/dev';
import FishingMinigame from './features/minigame/FishingMinigame';
import FishingTablet from './features/tablet/FishingTablet';

const App: React.FC = () => {

  return (
    <>
      <FishingMinigame />
      <FishingTablet />
      {isEnvBrowser() && <Dev />}
    </>
  );
};

export default App;