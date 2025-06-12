import { useDrag } from 'react-dnd';
import type { SellProps, ShopProps } from "../../../../typings/tablet";
import { getColor } from '../Shop';
import { useState } from 'react';
import ContextMenu from '../sell/ContextMenu';

type DraggableItemProps = {
    item: ShopProps | SellProps;
    index?: number;
};

const DraggableItem = ({ item, index }: DraggableItemProps) => {
    const [{ isDragging }, dragRef] = useDrag(() => ({
        type: 'ITEM',
        item: { ...item, index },
        collect: (monitor) => ({
            isDragging: monitor.isDragging(),
        }),
    }));

    const color = getColor(item.rarity || 'common');
    const [menuPosition, setMenuPosition] = useState<{ x: number; y: number } | null>(null);

    const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        setMenuPosition({
            x: e.clientX - rect.left,
            y: e.clientY - rect.top,
        });
    };

    const handleMouseLeave = () => {
        setMenuPosition(null);
    };

    return (
        <div
            ref={dragRef as unknown as React.Ref<HTMLDivElement>}
            className="card"
            onMouseMove={handleMouseMove}
            onMouseLeave={handleMouseLeave}
            style={{
                background: color.background,
                color: color.text,
                borderBottom: `3px solid ${color.text}`,
                '--borderColor': color.text,
                opacity: isDragging ? 0.5 : 1,
                cursor: 'pointer',
            } as React.CSSProperties}

        >
            <p className="rarity" style={{ color: item.rarity === 'common' ? '#ffffff' : '' }}>
                {item.rarity?.toUpperCase() || 'COMMON'}
            </p>
            <img src={item.imageUrl} />
            <div className="card-bottom">
                <p className="label">{item.label}</p>
                <p className="price">${item.price.toLocaleString('en-US')}</p>
            </div>

            { !('name' in item) && <ContextMenu item={item as SellProps} position={menuPosition} isDragging={isDragging} /> }
        </div>
    );
};

export default DraggableItem;