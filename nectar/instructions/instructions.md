# Product Requirements Document (PRD) for Nectar - Grocery Delivery App

## 1. Introduction
Nectar is an iOS application that provides a seamless grocery delivery service to users. The app aims to simplify the grocery shopping experience by offering a wide selection of fresh produce, pantry items, and household essentials, delivered directly to the user's doorstep.

## 2. User Personas
1. **Busy Professionals**: These users are typically working adults with limited time for grocery shopping. They value the convenience of on-demand delivery and a user-friendly app experience.
2. **Families with Children**: Parents who need to manage their household responsibilities efficiently. They appreciate the ability to order groceries from the comfort of their homes and have them delivered promptly.
3. **Elderly or Mobility-Impaired Users**: This group may have difficulty traveling to physical stores. They benefit from the accessibility and convenience of a grocery delivery app.

## 3. Features

### 3.1 User Authentication
- **Login and Sign-up**: Users should be able to create an account and log in using various methods, such as email/password, phone number, or social media platforms (e.g., Google, Facebook).
- **Country Selector**: Users should be able to select their country during the sign-up process to ensure accurate location-based services and payment integration.

### 3.2 Home Page
- **Store and Grocery Recommendations**: The home page should display a curated selection of nearby stores and popular grocery items based on the user's location and previous shopping behavior.
- **Search Functionality**: Users should be able to search for specific stores, groceries, or categories using a search bar.

### 3.3 User Account Management
- **Profile Section**: Users should be able to view and edit their personal information, including name, email, phone number, and delivery address.
- **Cart**: Users should be able to add, remove, and manage the items in their shopping cart.
- **Wishlist**: Users should be able to save their favorite items to a wishlist for easy access during future shopping trips.

### 3.4 Order Management
- **Order History**: Users should be able to view their previous orders, including order details, delivery status, and the ability to reorder items.
- **Push Notifications**: Users should receive push notifications for order updates, such as when their order has been placed, is being prepared, or has been delivered.

### 3.5 Payment Integration
- **Secure Payment Options**: Users should be able to securely add and manage their payment methods, including credit/debit cards and mobile wallets.
- **Order Checkout**: Users should be able to proceed to checkout, review their order details, and complete the purchase using their preferred payment method.

## 4. Requirements of Features

### 4.1 User Authentication
- **Registration**: Users should be able to register using email, phone number, or social media accounts.
- **Login**: Users should be able to log in using their registered credentials.
- **Password Reset**: Users should be able to reset their password if they forget it.

### 4.2 Home Page
- **Location-based Recommendations**: The app should use the user's location to provide relevant store and grocery recommendations.
- **Search Functionality**: Users should be able to search for specific items or categories using keywords.
- **Sorting and Filtering**: Users should be able to sort and filter the search results based on various criteria (e.g., price, rating, availability).

### 4.3 User Account Management
- **Profile Editing**: Users should be able to update their personal information, such as name, email, and phone number.
- **Address Management**: Users should be able to add, edit, and delete their delivery addresses.
- **Cart Management**: Users should be able to add, remove, and update the quantities of items in their cart.
- **Wishlist Management**: Users should be able to add, remove, and view items in their wishlist.

### 4.4 Order Management
- **Order History**: Users should be able to view their past orders, including order details, delivery status, and the ability to reorder items.
- **Order Tracking**: Users should be able to track the status of their current orders in real-time.
- **Push Notifications**: Users should receive push notifications for order updates, such as order confirmation, order preparation, and order delivery.

### 4.5 Payment Integration
- **Payment Methods**: Users should be able to add, edit, and delete their payment methods, including credit/debit cards and mobile wallets.
- **Checkout Process**: Users should be able to review their cart, apply any applicable discounts or promotions, and complete the purchase using their preferred payment method.
- **Order Confirmation**: Users should receive an order confirmation after a successful purchase, including order details and a summary of the transaction.

## 5. Data Models

### 5.1 User
- `userId`: Unique identifier for the user
- `name`: User's full name
- `email`: User's email address
- `phoneNumber`: User's phone number
- `password`: User's hashed password
- `deliveryAddresses`: List of user's delivery addresses
- `paymentMethods`: List of user's payment methods
- `cart`: List of items in the user's cart
- `wishlist`: List of items in the user's wishlist
- `orderHistory`: List of the user's past orders

### 5.2 Store
- `storeId`: Unique identifier for the store
- `name`: Store name
- `address`: Store's physical address
- `coordinates`: Latitude and longitude of the store location
- `inventory`: List of available products and their quantities

### 5.3 Product
- `productId`: Unique identifier for the product
- `name`: Product name
- `description`: Product description
- `category`: Product category (e.g., produce, pantry, household)
- `price`: Product price
- `imageUrl`: URL of the product image
- `inStock`: Boolean indicating if the product is in stock

### 5.4 Order
- `orderId`: Unique identifier for the order
- `userId`: ID of the user who placed the order
- `items`: List of ordered items and their quantities
- `totalAmount`: Total amount of the order
- `paymentMethod`: Payment method used for the order
- `deliveryAddress`: Delivery address for the order
- `status`: Current status of the order (e.g., pending, in-progress, delivered)
- `createdAt`: Timestamp of when the order was placed
- `updatedAt`: Timestamp of the last order status update

## 6. API Contract

### 6.1 User Authentication
- **Register User**: `POST /users`
  - Request Body: `{ name, email, phoneNumber, password }`
  - Response: `{ userId, name, email, phoneNumber }`
- **Login User**: `POST /login`
  - Request Body: `{ email, password }`
  - Response: `{ userId, authToken }`
- **Reset Password**: `POST /password-reset`
  - Request Body: `{ email }`
  - Response: `{ message }`

### 6.2 Home Page
- **Get Recommended Stores**: `GET /stores/recommended?latitude=&longitude=`
  - Response: `[ { storeId, name, address, coordinates, inventory } ]`
- **Search Products**: `GET /products?query=&category=&sort=&filter=`
  - Response: `[ { productId, name, description, category, price, imageUrl, inStock } ]`

### 6.3 User Account Management
- **Update User Profile**: `PATCH /users/{userId}`
  - Request Body: `{ name, email, phoneNumber }`
  - Response: `{ userId, name, email, phoneNumber }`
- **Manage Delivery Addresses**: `GET /users/{userId}/addresses`, `POST /users/{userId}/addresses`, `PATCH /users/{userId}/addresses/{addressId}`, `DELETE /users/{userId}/addresses/{addressId}`
- **Manage Payment Methods**: `GET /users/{userId}/payment-methods`, `POST /users/{userId}/payment-methods`, `PATCH /users/{userId}/payment-methods/{paymentMethodId}`, `DELETE /users/{userId}/payment-methods/{paymentMethodId}`
- **Manage Cart**: `GET /users/{userId}/cart`, `POST /users/{userId}/cart`, `PATCH /users/{userId}/cart/{itemId}`, `DELETE /users/{userId}/cart/{itemId}`
- **Manage Wishlist**: `GET /users/{userId}/wishlist`, `POST /users/{userId}/wishlist`, `DELETE /users/{userId}/wishlist/{itemId}`

### 6.4 Order Management
- **Place Order**: `POST /orders`
  - Request Body: `{ userId, items, deliveryAddress, paymentMethod }`
  - Response: `{ orderId, totalAmount, status, createdAt }`
- **Get Order History**: `GET /users/{userId}/orders`
  - Response: `[ { orderId, items, totalAmount, status, createdAt, updatedAt } ]`
- **Track Order**: `GET /orders/{orderId}`
  - Response: `{ orderId, items, totalAmount, status, createdAt, updatedAt }`

## 7. Roadmap and Milestones
1. **Phase 1 (MVP)**: Implement the core features, including user authentication, home page with store and grocery recommendations, cart management, and basic order history.
2. **Phase 2**: Introduce advanced features, such as the wishlist, push notifications, and payment integration.
3. **Phase 3**: Enhance the user experience with features like personalized recommendations, order tracking, and integration with third-party services (e.g., loyalty programs).
4. **Phase 4**: Expand the app's capabilities, such as support for subscription-based deliveries, in-app chat support, and integration with smart home devices.

## 8. Conclusion
The Nectar grocery delivery app aims to revolutionize the way users approach their grocery shopping needs. By providing a seamless and convenient experience, the app will cater to the diverse needs of busy professionals, families, and mobility-impaired individuals, making their lives easier and more efficient.