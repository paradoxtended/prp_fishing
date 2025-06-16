import React from 'react';
import { useDrop } from 'react-dnd';
import DraggableItem from '../shop/DraggableItem';
import type { SellProps } from '../../../../typings/tablet';

type InventoryGridProps = {
    items: (SellProps | null)[];
    section: 'inv' | 'cart';
    setInventory: React.Dispatch<React.SetStateAction<{
        inv: (SellProps | null)[];
        cart: (SellProps | null)[];
    }>>;
};

const InventoryGrid: React.FC<InventoryGridProps> = ({ items, section, setInventory }) => {
    const moveItem = (
        fromSection: 'inv' | 'cart',
        fromIndex: number,
        toSection: 'inv' | 'cart',
        toIndex: number
    ) => {
        setInventory((prev) => {
            const newInv = [...prev.inv];
            const newCart = [...prev.cart];

            const sections: Record<string, (SellProps | null)[]> = {
                inv: newInv,
                cart: newCart,
            };

            const temp = sections[toSection][toIndex];
            sections[toSection][toIndex] = sections[fromSection][fromIndex];
            sections[fromSection][fromIndex] = temp;

            return {
                inv: newInv,
                cart: newCart,
            };
        });
    };

    return (
        <div className="inv">
            {items.map((item, index) => (
                <InventorySlot
                    key={index}
                    index={index}
                    item={item}
                    section={section}
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
    section: 'inv' | 'cart';
    moveItem: (
        fromSection: 'inv' | 'cart',
        fromIndex: number,
        toSection: 'inv' | 'cart',
        toIndex: number
    ) => void;
}> = ({ index, item, section, moveItem }) => {
    const [, dropRef] = useDrop({
        accept: 'ITEM',
        drop: (dragged: { index: number; section: 'inv' | 'cart' }) => {
            if (dragged.index !== index || dragged.section !== section) {
                moveItem(dragged.section, dragged.index, section, index);
            }
        }
    });

    return (
        <div ref={dropRef as unknown as React.Ref<HTMLDivElement>} className="slot">
            {item ? <DraggableItem key={item.label} item={item} slotIndex={index} section={section} /> : <div className="empty-slot" />}
        </div>
    );
};