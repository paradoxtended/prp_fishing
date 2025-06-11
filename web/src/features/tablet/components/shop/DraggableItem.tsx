// components/DraggableItem.tsx
import { useDrag } from 'react-dnd';
import type { ShopProps } from "../../../../typings/tablet";
import { getColor } from '../Shop';

const DraggableItem = ({ item }: { item: ShopProps }) => {
    const [{ isDragging }, dragRef] = useDrag(() => ({
        type: 'ITEM',
        item,
        collect: (monitor) => ({
            isDragging: monitor.isDragging(),
        }),
    }));

    const color = getColor(item.rarity || 'common');

    return (
        <div
        ref={dragRef as unknown as React.Ref<HTMLDivElement>}
        className="card"
        style={{
            background: color.background,
            color: color.text,
            borderBottom: `3px solid ${color.text}`,
            '--borderColor': color.text,
            opacity: isDragging ? 0.5 : 1,
            cursor: 'pointer',
        } as React.CSSProperties }
        >
            <p className="rarity" style={{ color: item.rarity == 'common' ? '#ffffff' : '' }}>{item.rarity?.toUpperCase() || 'COMMON'}</p>
            <img src={item.imageUrl} />
            <div className="card-bottom">
                <p className="label">{item.label}</p>
                <p className="price">${item.price.toLocaleString('en-US')}</p>
            </div>
        </div>
    );
};

export default DraggableItem;