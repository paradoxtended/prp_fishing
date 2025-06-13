import type { SellProps } from "../../../../typings/tablet";

type ContextMenuProps = {
    item: SellProps;
    position: { x: number; y: number } | null;
    isDragging: boolean;
};

const ContextMenu: React.FC<ContextMenuProps> = ({ item, position, isDragging }) => {
    if (!position || isDragging) return null;

    return (
        <div
            className="contextMenu"
            style={{
                top: position.y + 15,
                left: position.x,
                transform: 'translate(-50%)'
            }}
            onMouseDown={(e) => e.stopPropagation()}
        >
            <div className="metadata">
                <p className="value">{item.label}</p>
            </div>

            {item.metadata && item.metadata.map((item, index) => (
                <div className="metadata" key={index}>
                    <p className="label">{item?.label}</p>
                    <p className="value">{item.value}</p>
                </div>
            ))}
        </div>
    )
};

export default ContextMenu