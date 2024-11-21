# Role-Based Authorization Setup in Jenkins

This README explains the steps taken to configure **Role-Based Authorization** in Jenkins, referring to the usernames and configurations shown in the screenshots.

## Purpose

Role-Based Authorization helps manage user permissions effectively in Jenkins by defining roles with specific access rights and assigning these roles to users or groups.

## Steps to Set Up Role-Based Authorization

### 1. Install the Role-Based Authorization Strategy Plugin
   - Navigate to **Manage Jenkins > Manage Plugins > Available**.
   - Search for **Role-Based Authorization Strategy**.
   - Click **Install without restart** and wait for the installation to complete.
   - Restart Jenkins if required.

### 2. Enable Role-Based Authorization Strategy
   - Go to **Manage Jenkins > Configure Global Security**.
   - Under the **Authorization** section, select **Role-Based Strategy**.
   - Save the changes.

### 3. Define Roles
   - Navigate to **Manage Jenkins > Manage and Assign Roles > Manage Roles**.
   - Define roles with specific permissions:
     - **Admin**: Full access to Jenkins.
     - **Developer**: Access to create, read, and build jobs.
     - **Viewer**: Read-only access.
   - Set permissions for each role using the checkboxes.

### 4. Assign Users to Roles
   - Navigate to **Manage Jenkins > Manage and Assign Roles > Assign Roles**.
   - Assign the following roles to users:
     - **saumya**: Assigned the **Admin** role for full system access.
     - **python-dev-1**: Assigned the **Developer** role for job-related activities.
     - **python-dev-2**: Assigned the **Developer** role for job-related activities.
     - **web-user-1**: Assigned the **Viewer** role for read-only access.

### 5. Verify Role Assignments
   - Log in with each user account to confirm their permissions:
     - **saumya**: Full access to all Jenkins features.
     - **python-dev-1** and **python-dev-2**: Limited access to create, build, and manage jobs.
     - **web-user-1**: Restricted to read-only access.

## Results

- **Admin View (saumya)**: Full access to Jenkins, including user management and system configuration.
- **Developer View (python-dev-1, python-dev-2)**: Limited access to job creation, builds, and configurations.
- **Viewer View (web-user-1)**: Read-only access to view job statuses and logs.

## Screenshots

1. **Manage Roles Interface**:
   - Shows roles and their corresponding permissions.

2. **Assign Roles Interface**:
   - Displays user-role assignments:
     - **Global Roles**: saumya, python-dev-1, python-dev-2, web-user-1.

3. **Jenkins Dashboard for Different Roles**:
   - Demonstrates the dashboard view for users with varying permissions.

## Additional Notes

- Regularly review roles and permissions to ensure compliance with security requirements.
- Ensure that the **Admin** role is assigned only to trusted users (e.g., **saumya**) to prevent unauthorized changes.
- Refer to the [Jenkins Role-Based Authorization Plugin Documentation](https://plugins.jenkins.io/role-strategy/) for advanced configurations.

---
This setup enhances Jenkins security by enforcing strict role-based access control and simplifying user management.













