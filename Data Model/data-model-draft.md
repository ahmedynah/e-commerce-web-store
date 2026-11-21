**Product**
- Product ID
- Name
- Short Description
- Long Description
- Size
- Color
- Image URL
- Weight
- Availability (quantity on hand)
- shipping cost
- Price
- status (active/deleted)

**Comments**:
 - Comment ID
 - Product ID
 - Customer ID
 - Comment text
 - Comment date


**Order**:
- Order ID
- Customer ID
- Product(s) ordered
- Quantity of each product
- Total shipping cost
- Taxes (if any)
- Total cost
- Order date

**Discount**:
 - Discount ID
 - Discount code
 - Discount description
 - Discount amount
 - Discount percentage
 - Validity period (start and end date)

**Category**: 
 - Category ID
 - Category name
 - Description.

**Customer**: 
 - Customer ID
 - Customer name
 - E-mail address
 - Customer password.
 - Customer address
 - Phone number

**Product Category**:
 - Product Category ID
 - Product ID
 - Category ID

**Order Item**:
 - Order Item ID
 - Order ID
 - Product ID
 - Product quantity

**Order Discount**:
 - Order Discount ID
 - Order ID
 - Discount ID

**Customer Discount**:
 - Customer ID
 - Discount ID


 - product must belong to one or multiple categories.
 - product should have a status indicator (active/deleted) to preserve historical order records.
 - product can have zero or one or multiple comment(s).
 - product can have zero or one or multiple order(s).
 - customer can have zero or one or multiple order(s).
 - order must have at least one product.
 - order can have zero or one or multiple discount(s).
 - discount can be applied to zero or one or multiple order(s).
 - category can have zero or one or multiple product(s).
 - comment must be associated with one customer and one product.
 - customer can have zero or one or multiple comment(s).
 - customer can have zero or one or multiple discount(s).
 - discount can be associated with zero or one or multiple customer(s).