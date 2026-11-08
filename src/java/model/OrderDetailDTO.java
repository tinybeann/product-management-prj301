package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class OrderDetailDTO extends OrderDetail implements Serializable {

    private double totalPrice;

    public OrderDetailDTO() {
        super();
    }

    public OrderDetailDTO(int orderDetailId, int orderId, int productId,
                          String productName, String imageUrl,
                          int quantity, BigDecimal unitPrice) {
        super(orderDetailId, orderId, productId, quantity, unitPrice);
        setProductName(productName);
        setImageUrl(imageUrl);
        this.totalPrice = (unitPrice != null) ? unitPrice.doubleValue() * quantity : 0.0;
    }

    @Override
    public double getTotalPrice() {
        if (getUnitPrice() != null) {
            return getUnitPrice().doubleValue() * getQuantity();
        }
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }
}
