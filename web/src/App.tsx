import { isEnvBrowser } from './utils/misc';
import Dev from './features/dev';
import FishingMinigame from './features/minigame/FishingMinigame';
import FishingTablet from './features/tablet/FishingTablet';
import { fetchNui } from './utils/fetchNui';

const App: React.FC = () => {
  setTimeout(() => fetchNui('init'), 500)

  return (
    <>
      <FishingMinigame />
      <FishingTablet />
      {isEnvBrowser() && <Dev />}
    </>
  );
};

export default App;