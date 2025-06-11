import { isEnvBrowser } from './utils/misc';
import Dev from './features/dev';
import FishingMinigame from './features/minigame/FishingMinigame';
import FishingTablet from './features/tablet/FishingTablet';
import { fetchNui } from './utils/fetchNui';
import DragPreview from './features/tablet/components/shop/DragPreview';

const App: React.FC = () => {
  setTimeout(() => fetchNui('init'), 500)

  return (
    <>
      <FishingMinigame />
      <FishingTablet />
      <DragPreview />
      {isEnvBrowser() && <Dev />}
    </>
  );
};

addEventListener("dragstart", function(event) {
  event.preventDefault()
})

export default App;