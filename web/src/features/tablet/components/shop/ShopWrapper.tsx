import { DndProvider } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';
import Shop from '../Shop';
import type { ShopProps } from '../../../../typings/tablet';

type ShopProperties = {
    items: ShopProps[]
};

const ShopWrapper: React.FC<ShopProperties> = (props) => (
  <DndProvider backend={HTML5Backend}>
    <Shop {...props} />
  </DndProvider>
);

export default ShopWrapper;