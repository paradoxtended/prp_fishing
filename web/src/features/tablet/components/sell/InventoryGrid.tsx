import React from 'react';
import { useDrop } from 'react-dnd';
import DraggableItem from '../shop/DraggableItem';
import type { SellProps } from '../../../../typings/tablet';

type InventoryGridProps = {
    items: SellProps[];
    setItems: React.Dispatch<React.SetStateAction<SellProps[]>>;
};

const InventoryGrid: React.FC<InventoryGridProps> = ({ items, setItems }) => {
    const moveItem = (fromIndex: number, toIndex: number) => {
        setItems((prevItems) => {
            const updated = [...prevItems];
            const temp = updated[toIndex];
            updated[toIndex] = updated[fromIndex];
            updated[fromIndex] = temp;
            return updated;
        });
    };

    return (
        <div className="inv">
            {Array.from({ length: 16 }).map((_, index) => (
                <InventorySlot
                    key={index}
                    index={index}
                    item={items[index] || null}
                    moveItem={moveItem}
                />
            ))}
        </div>
    );
};

export default InventoryGrid;

// Helper component: slot with drop logic
const InventorySlot: React.FC<{
    index: number;
    item: SellProps | null;
    moveItem: (from: number, to: number) => void;
}> = ({ index, item, moveItem }) => {
    const [, dropRef] = useDrop({
        accept: 'ITEM',
        drop: (dragged: { index: number }) => {
            if (dragged.index !== index) {
                moveItem(dragged.index, index);
            }
        }
    });

    return (
        <div ref={dropRef as unknown as React.Ref<HTMLDivElement>} className="slot">
            {item ? <DraggableItem item={item} index={index} /> : <div className="empty-slot" />}
        </div>
    );
};