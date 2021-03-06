/*
* Copyright (C) 2017
*
* This program or library is free software; you can redistribute it
* and/or modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General
* Public License along with this library; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA.
*
* Authored by: Felipe Escoto <felescoto95@hotmail.com>
*/

/**
 * CanvasItem is a {@link Clutter.Actor} which is the base class of all items that can appear on the Canvas.
 *
 * This class should take care of the basics such as dragging, clicks and rotation,
 * and leave more specific implementations to child classes.
 */
public class Gcav.CanvasItem : Clutter.Actor, Gcav.Item {

    private MoveAction move_action;
    private HoverAction hover_action;

    /**
    * Sets if the hover effect should appear when you hover on this. Disabling the effect if currently visible;
    */
    public bool on_hover_effect {
        get {
            return _on_hover_effect;
        } set {
            if (!value) {
                hover_action.toggle (false);
            }

            _on_hover_effect = value;
        }
    }
    private bool _on_hover_effect = true;

    /**
     * True if this is currently being dragged
     */
    public bool dragging { get; internal set; default = false; }

    /**
     * True if this was just clicked, but not yet moved
     */
    public bool clicked { get; internal set; default = false; }

    /**
    * Sets the position x of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public float real_x {
        get {
            return _real_x;
        } set {
            _real_x = value;
            apply_ratio (ratio);
        }
    }
    private float _real_x;

    /**
    * Sets the position y of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public float real_y {
        get {
            return _real_y;
        } set {
            _real_y = value;
            apply_ratio (ratio);
        }
    }
    private float _real_y;

    /**
    * Sets the height of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public float real_w {
        get {
            return _real_w;
        } set {
            _real_w = value;
            apply_ratio (ratio);
        }
    }
    private float _real_w;

    /**
    * Sets the width of this shape on the canvas.
    *
    * Doing this causes an update on the aspect ratio. So it's better to use set_rectangle
    */
    public float real_h {
        get {
            return _real_h;
        } set {
            _real_h = value;
            apply_ratio (ratio);
        }
    }
    private float _real_h;

    /**
     * The item's rotation. From 0 to 360 degrees
     */
    public double rotation {
        get {
            return _rotation;
        } set {
            if (value < 0) return;

            _rotation = value % 360;
            rotation_angle_z = value % 360;
            updated ();
        }
    }
    private double _rotation = 0.0;

    /**
     * Ratio relative to the container to properly scale all the elements
     */
    public float ratio { get; set; default = 1.0f; }

    public CanvasItem.with_values (float x, float y, float w, float h, string color) {
        Object (background_color: Clutter.Color.from_string (color));
        set_rectangle (x, y, w, h);
    }

    public CanvasItem () {
        set_rectangle (0, 0, 100, 100);
    }

    construct {
        reactive = true;
        set_pivot_point (0.5f, 0.5f);

        move_action = new MoveAction (this);
        hover_action = new HoverAction (this);

        enter_event.connect (() => {
            if (on_hover_effect) {
                hover_action.toggle (true);
            }
        });

        leave_event.connect (() => {
            if (on_hover_effect) {
                hover_action.toggle (false);
            }
        });
    }

    /**
    * Set's the coordenates and size of this, ignoring nulls. Use this to set multiple "real_n" properties without causing uneeded updates.
    */
    public void set_rectangle (float? x, float? y, float? w, float? h) {
        if (x != null) {
            _real_x = x;
        }

        if (y != null) {
            _real_y = y;
        }

        if (w != null) {
            _real_w = w;
        }

        if (h != null) {
            _real_h = h;
        }

        apply_ratio (ratio);
    }

    internal void apply_ratio (float ratio) {
        this.ratio = ratio;

        width =  (real_w  * ratio);
        height = (real_h * ratio);
        x = (real_x * ratio);
        y = (real_y * ratio);

        updated ();
    }
}
