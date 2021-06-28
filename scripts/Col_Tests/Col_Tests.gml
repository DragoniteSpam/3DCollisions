function ColTestPoint(vbuff) constructor {
    self.data = new ColPoint(new Vector3(0, 0, 0));
    self.vbuff = vbuff;
    
    self.update = function() {
        if (keyboard_check(vk_left)) {
            self.data.position.x--;
        }
        if (keyboard_check(vk_right)) {
            self.data.position.x++;
        }
        if (keyboard_check(vk_up)) {
            self.data.position.y--;
        }
        if (keyboard_check(vk_down)) {
            self.data.position.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.data.position.z--;
        }
        if (keyboard_check(vk_pagedown)) {
            self.data.position.z++;
        }
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(self.data.position.x, self.data.position.y, self.data.position.z, 0, 0, 0, 1, 1, 1));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data.CheckPoint(self.data);
    };
}

function ColTestSphere(vbuff) constructor {
    self.data = new ColSphere(new Vector3(0, 0, 0), 8);
    self.vbuff = vbuff;
    
    self.update = function() {
        if (keyboard_check(vk_left)) {
            self.data.position.x--;
        }
        if (keyboard_check(vk_right)) {
            self.data.position.x++;
        }
        if (keyboard_check(vk_up)) {
            self.data.position.y--;
        }
        if (keyboard_check(vk_down)) {
            self.data.position.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.data.position.z--;
        }
        if (keyboard_check(vk_pagedown)) {
            self.data.position.z++;
        }
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(
            self.data.position.x, self.data.position.y, self.data.position.z,
            0, 0, 0,
            self.data.radius, self.data.radius, self.data.radius
        ));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data.CheckSphere(self.data);
    };
}

function ColTestAABB(vbuff) constructor {
    self.data = new ColAABB(new Vector3(0, 0, 0), new Vector3(irandom_range(2, 8), irandom_range(2, 8), irandom_range(2, 8)));
    self.vbuff = vbuff;
    
    self.update = function() {
        if (keyboard_check(vk_left)) {
            self.data.position.x--;
        }
        if (keyboard_check(vk_right)) {
            self.data.position.x++;
        }
        if (keyboard_check(vk_up)) {
            self.data.position.y--;
        }
        if (keyboard_check(vk_down)) {
            self.data.position.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.data.position.z--;
        }
        if (keyboard_check(vk_pagedown)) {
            self.data.position.z++;
        }
    };
    self.draw = function() {
        matrix_set(matrix_world, matrix_build(
            self.data.position.x, self.data.position.y, self.data.position.z,
            0, 0, 0,
            self.data.half_extents.x, self.data.half_extents.y, self.data.half_extents.z
        ));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data.CheckAABB(self.data);
    };
}

function ColTestPlane(vbuff) constructor {
    self.rotation = 0;
    self.data = new ColPlane(new Vector3(0, dsin(self.rotation), dcos(self.rotation)), 0);
    self.vbuff = vbuff;
    
    self.update = function() {
        if (keyboard_check(vk_up)) {
            self.data.distance++;
        }
        if (keyboard_check(vk_down)) {
            self.data.distance--;
        }
        
        if (keyboard_check(vk_right)) {
            self.rotation--;
            self.data.normal = new Vector3(0, dsin(self.rotation), dcos(self.rotation));
        }
        if (keyboard_check(vk_left)) {
            self.rotation++;
            self.data.normal = new Vector3(0, dsin(self.rotation), dcos(self.rotation));
        }
    };
    self.draw = function() {
        var mat1 = matrix_build(0, 0, 0, self.rotation, 0, 0, 100, 100, 100);
        matrix_set(matrix_world, matrix_multiply(mat1, matrix_build(0, self.data.distance * dsin(self.rotation), self.data.distance * dcos(self.rotation), 0, 0, 0, 1, 1, 1)));
        vertex_submit(self.vbuff, pr_trianglelist, -1);
        matrix_set(matrix_world, matrix_build_identity());
    };
    self.test = function(shape) {
        return shape.data.CheckPlane(self.data);
    };
}

function ColTestLine(vbuff) constructor {
    self.data = new ColLine(new Vector3(0, 100, 0), new Vector3(0, -100, 0));
    self.rotation = 0;
    self.offset = { x: 0, y: 0 };
    
    self.update = function() {
        if (keyboard_check(vk_left)) {
            self.offset.x--;
        }
        if (keyboard_check(vk_right)) {
            self.offset.x++;
        }
        if (keyboard_check(vk_up)) {
            self.offset.y--;
        }
        if (keyboard_check(vk_down)) {
            self.offset.y++;
        }
        if (keyboard_check(vk_pageup)) {
            self.rotation++;
        }
        if (keyboard_check(vk_pagedown)) {
            self.rotation--;
        }
        self.data.start.x = 100 * dcos(self.rotation) + self.offset.x;
        self.data.start.y = 100 * dsin(self.rotation) + self.offset.y;
        self.data.finish.x = -100 * dcos(self.rotation) + self.offset.x;
        self.data.finish.y = -100 * dsin(self.rotation) + self.offset.y;
    };
    self.draw = function() {
        var vbuff = vertex_create_buffer();
        vertex_begin(vbuff, obj_demo.vertex_format);
        vertex_position_3d(vbuff, self.data.start.x, self.data.start.y, self.data.start.z);
        vertex_normal(vbuff, 0, 0, 1);
        vertex_colour(vbuff, c_lime, 1);
        vertex_position_3d(vbuff, self.data.finish.x, self.data.finish.y, self.data.finish.z);
        vertex_normal(vbuff, 0, 0, 1);
        vertex_colour(vbuff, c_lime, 1);
        vertex_end(vbuff);
        vertex_submit(vbuff, pr_linelist, -1);
        vertex_delete_buffer(vbuff);
    };
    self.test = function(shape) {
        return shape.data.CheckLine(self.data);
    };
}